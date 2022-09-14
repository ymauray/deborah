import 'dart:async';

import 'package:csv/csv.dart';
import 'package:deborah/models/software.dart';
import 'package:deborah/utils/deb_get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// This provider is used to store the version of this package.
final packageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

/// This provider is used to store the version of debget.
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

/// This provider is used to store the state of the menu
final menuEnabledProvider = StateProvider<bool>((ref) => true);

enum SelectedMenuItemEnum {
  applications,
  updates,
  options,
  refresh,
}

/// This provider is used to store the selected menu item
final selectedMenuItemProvider = StateProvider<SelectedMenuItemEnum>(
  (ref) => SelectedMenuItemEnum.applications,
);

/// This provider is used to store the status line
final statusLineProvider = StateProvider<String>((ref) => 'Ready.');

class SoftwaresNotifier extends StateNotifier<List<Software>> {
  SoftwaresNotifier(this.ref) : super(<Software>[]);

  StateNotifierProviderRef<SoftwaresNotifier, List<Software>> ref;

  // ignore: long-method
  void refresh() {
    final applications = <String, Software>{};

    Future<void> parseCsvlistOutput(String lines) async {
      const converter = CsvToListConverter();

      for (final line in lines.split('\n')) {
        final rows = converter.convert<String>(
          line,
          shouldParseNumbers: false,
        );
        if (rows.isEmpty) continue;
        final columns = rows[0];
        if (columns.length != 6) continue;
        final packageName = columns[0].trim();
        final prettyName = columns[1].trim();
        final installedVersion = columns[2].trim();
        final architecture = columns[3].trim();
        final method = columns[4].trim();
        final description = columns[5].trim();
        final icon = ((String method) {
          switch (method) {
            case 'apt':
              return 'debian.png';
            case 'github':
              return 'github.png';
            case 'ppa':
              return 'launchpad.png';
            default:
              return 'direct.png';
          }
        })(method);

        final software = Software(
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

        ref.read(statusLineProvider.notifier).state =
            'Loading : ${software.prettyName}';
      }
    }

    ref.read(menuEnabledProvider.notifier).state = false;
    DebGet.run(
      ['csvlist'],
      parseCsvlistOutput,
      (exitCode) {
        ref.read(menuEnabledProvider.notifier).state = true;
        ref.read(statusLineProvider.notifier).state = 'Ready';
        state = [for (final app in applications.values) app];
      },
    );
  }

  // ignore: long-method
  void install(Software software) {
    ref.read(menuEnabledProvider.notifier).state = false;
    ref.read(statusLineProvider.notifier).state =
        'Installing ${software.prettyName}';
    DebGet.run(
      ['install', software.packageName],
      elevate: true,
      (line) {
        var status = line.replaceAll('\n', ' ').trim();
        if (status.length > 140) status = status.substring(0, 140);
        if (status.isNotEmpty) {
          ref.read(statusLineProvider.notifier).state = 'Installing : $status';
        }
      },
      (exitCode) {
        ref.read(menuEnabledProvider.notifier).state = true;
        ref.read(statusLineProvider.notifier).state =
            'Installed ${software.prettyName}';
        refreshApp(software);
      },
    );
  }

  void remove(Software software) {
    ref.read(menuEnabledProvider.notifier).state = false;
    ref.read(statusLineProvider.notifier).state =
        'Removing ${software.prettyName}';
    DebGet.run(
      ['remove', software.packageName],
      elevate: true,
      (line) {
        var status = line.replaceAll('\n', ' ').trim();
        if (status.length > 140) status = status.substring(0, 140);
        if (status.isNotEmpty) {
          ref.read(statusLineProvider.notifier).state = 'Removing : $status';
        }
      },
      (exitCode) {
        ref.read(menuEnabledProvider.notifier).state = true;
        ref.read(statusLineProvider.notifier).state =
            'Removed ${software.prettyName}';
        refreshApp(software);
      },
    );
  }

  void refreshApp(Software software) {
    final lines = <String>[];
    DebGet.run(
      ['show', software.packageName],
      (line) {
        lines.addAll(line.split('\n').map((e) => e.trim()));
      },
      (exitCode) {
        software
          ..info = lines
              .skip(1)
              .where(
                (element) =>
                    !element.startsWith('Package') &&
                    !element.startsWith('Summary'),
              )
              .join('\n')
          ..installed = !(software.info?.contains('Installed:\tNo') ?? false);

        if (software.installed) {
          final r = RegExp(r'Installed:\s*(.*)\n');
          final m = r.firstMatch(software.info ?? '');
          software.installedVersion = m?.group(1) ?? '';
        } else {
          software.installedVersion = '';
        }
        state = [
          for (final app in state)
            if (app.packageName == software.packageName) software else app,
        ];
      },
    );
  }
}

final softwaresProvider =
    StateNotifierProvider<SoftwaresNotifier, List<Software>>(
  SoftwaresNotifier.new,
);

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredSoftwaresProvider = Provider<List<Software>>((ref) {
  final softwares = ref.watch(softwaresProvider);
  final query = ref.watch(searchQueryProvider);
  final onlyShowInstalledApps = ref.watch(onlyShowInstalledAppsProvider);
  final onlyShowUpgradableApps = ref.watch(onlyShowUpgradableAppsProvider);

  var apps = softwares;
  if (onlyShowInstalledApps) {
    apps = apps.where((app) => app.installedVersion != '').toList();
  }

  if (onlyShowUpgradableApps) {
    apps = apps.where((app) => false).toList();
  }

  if (query.isEmpty) return apps;

  return apps.where((app) {
    return app.packageName.contains(query) ||
        app.prettyName.contains(query) ||
        app.description.contains(query);
  }).toList();
});

final onlyShowInstalledAppsProvider = StateProvider<bool>((ref) => false);

final onlyShowUpgradableAppsProvider = StateProvider<bool>((ref) => false);
