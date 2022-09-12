import 'dart:async';

import 'package:csv/csv.dart';
import 'package:deborah/models/software.dart';
import 'package:deborah/utils/deb_get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

final debgetVersionProvider = FutureProvider<String>((ref) {
  final version = Completer<String>();

  DebGet.run(
    ['version'],
    (line) {
      version.complete(line.trim());
    },
    null,
  );

  return version.future;
});

final menuStateProvider = StateProvider<bool>((ref) => false);

enum SelectedMenuItemEnum {
  applications,
  updates,
  options,
  refresh,
}

final selectedMenuItemProvider = StateProvider<SelectedMenuItemEnum>(
  (ref) => SelectedMenuItemEnum.refresh,
);

class SoftwaresNotifier extends ChangeNotifier {
  final softwares = <Software>[];

  SoftwaresNotifier(this.ref);

  ChangeNotifierProviderRef<SoftwaresNotifier> ref;

  // ignore: long-method
  Stream<Software> refresh() {
    final controller = StreamController<Software>();
    final Map<String, Software> applications = {};

    void parseCsvlistOutput(String lines) async {
      var converter = const CsvToListConverter();

      for (var line in lines.split('\n')) {
        var rows = converter.convert(line);
        if (rows.isEmpty) continue;
        var columns = rows[0];
        if (columns.length != 6) continue;
        var packageName = columns[0].trim();
        var prettyName = columns[1].trim();
        var installedVersion = columns[2].trim();
        var architecture = columns[3].trim();
        var method = columns[4].trim();
        var description = columns[5].trim();
        var icon = ((method) {
          switch (method) {
            case "apt":
              return "debian.png";
            case "github":
              return "github.png";
            case "ppa":
              return "launchpad.png";
            default:
              return "direct.png";
          }
        })(method);

        var software = Software(
          packageName: packageName,
          prettyName: prettyName,
          description: description,
          icon: icon,
          installedVersion: installedVersion,
          architecture: architecture,
        );

        applications.putIfAbsent(
          packageName,
          () => software,
        );

        controller.add(software);
      }
    }

    DebGet.run(
      ['csvlist'],
      parseCsvlistOutput,
      (exitCode) {
        ref.read(menuStateProvider.notifier).state = true;
        ref.read(selectedMenuItemProvider.notifier).state =
            SelectedMenuItemEnum.applications;
        softwares.clear();
        softwares.addAll(applications.values);
        controller.close();
        notifyListeners();
      },
    );

    return controller.stream;
  }
}

final softwaresProvider =
    ChangeNotifierProvider<SoftwaresNotifier>((ref) => SoftwaresNotifier(ref));

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredSoftwaresProvider = Provider<List<Software>>((ref) {
  final softwares = ref.watch(softwaresProvider).softwares;
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) return softwares;

  return softwares.where((software) {
    return software.packageName.contains(query) ||
        software.prettyName.contains(query) ||
        software.description.contains(query);
  }).toList();
});
