import 'dart:async';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:deborah/models/app.dart';
import 'package:deborah/providers/debget_status_provider.dart';
import 'package:deborah/providers/menu_enabled_provider.dart';
import 'package:deborah/providers/status_line_provider.dart';
import 'package:deborah/utils/deb_get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppsNotifier extends StateNotifier<List<App>> {
  AppsNotifier(this.ref) : super(<App>[]);

  StateNotifierProviderRef<AppsNotifier, List<App>> ref;
  Map<String, Completer<App>> completers = <String, Completer<App>>{};

  // ignore: long-method
  void refresh() {
    final apps = <String, App>{};

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

        final app = App(
          packageName: packageName,
          prettyName: prettyName,
          description: description,
          icon: icon,
          installedVersion: installedVersion,
          architecture: architecture,
        );

        apps.putIfAbsent(
          packageName,
          () => app,
        );

        _updateStatusLine('Loading', app.prettyName);
      }
    }

    ref.read(menuEnabledProvider.notifier).state = false;
    DebGet.run(
      ['csvlist'],
      parseCsvlistOutput,
      (exitCode) {
        if (exitCode == -9999) {
          ref.read(debgetStatusProvider.notifier).state = false;
        }
        ref.read(menuEnabledProvider.notifier).state = true;
        ref.read(statusLineProvider.notifier).state = 'Ready';
        state = apps.values.toList();
        state.sort(
          (a, b) => a.prettyName.toLowerCase().compareTo(
                b.prettyName.toLowerCase(),
              ),
        );
      },
    );
  }

  // ignore: long-method
  void install(App app) {
    ref.read(menuEnabledProvider.notifier).state = false;
    ref.read(statusLineProvider.notifier).state =
        'Installing ${app.prettyName}';
    DebGet.run(
      ['install', app.packageName],
      elevate: true,
      (line) {
        _updateStatusLine('Installing', line);
      },
      (exitCode) {
        ref.read(menuEnabledProvider.notifier).state = true;
        ref.read(statusLineProvider.notifier).state =
            'Installed ${app.prettyName}';
        refreshApp(app);
      },
    );
  }

  void remove(App app) {
    ref.read(menuEnabledProvider.notifier).state = false;
    ref.read(statusLineProvider.notifier).state = 'Removing ${app.prettyName}';
    DebGet.run(
      ['remove', app.packageName],
      elevate: true,
      (line) {
        _updateStatusLine('Removing', line);
      },
      (exitCode) {
        ref.read(menuEnabledProvider.notifier).state = true;
        ref.read(statusLineProvider.notifier).state =
            'Removed ${app.prettyName}';
        refreshApp(app);
      },
    );
  }

  void refreshApp(App app) {
    final lines = <String>[];
    DebGet.run(
      ['show', app.packageName],
      (line) {
        lines.addAll(
          line.split('\n').where((e) => !e.trim().startsWith('[')),
        );
      },
      (exitCode) {
        app
          ..info = lines
              .where((line) => line.isNotEmpty)
              .skip(1)
              .where((line) => !line.startsWith('Summary'))
              .join('\n')
          ..installed = !(app.info?.contains('Installed:\tNo') ?? false);

        if (app.installed) {
          final r = RegExp(r'Installed:\s*(.*)\n');
          final m = r.firstMatch(app.info ?? '');
          app.installedVersion = m?.group(1) ?? '';
        } else {
          app.installedVersion = '';
        }
        state = [
          for (final updatedApp in state)
            if (updatedApp.packageName == app.packageName) app else updatedApp,
        ];
      },
    );
  }

  void checkUpdates() {
    ref.read(menuEnabledProvider.notifier).state = false;
    for (final app in state) {
      app.updateAvailable = false;
    }
    DebGet.run(
      ['update'],
      elevate: true,
      (line) {
        _updateStatusLine('Checking for updates', line);
        if (line.contains('has an update pending')) {
          final r = RegExp(r'.* (.*) \(.*\) has an update pending');
          final m = r.firstMatch(line);
          final packageName = m?.group(1);
          if (packageName != null) {
            state
                .firstWhere(
                  (element) => element.packageName == packageName,
                )
                .updateAvailable = true;
          }
        }
      },
      (exitCode) {
        ref.read(menuEnabledProvider.notifier).state = true;
        ref.read(statusLineProvider.notifier).state = 'Ready';
      },
    );
  }

  void update(App app) {
    ref.read(menuEnabledProvider.notifier).state = false;
    ref.read(statusLineProvider.notifier).state = 'Updating ${app.prettyName}';
    DebGet.run(
      ['reinstall', app.packageName],
      elevate: true,
      (line) {
        _updateStatusLine('Updating', line);
      },
      (exitCode) {
        app.updateAvailable = false;
        ref.read(menuEnabledProvider.notifier).state = true;
        ref.read(statusLineProvider.notifier).state =
            'Updated ${app.prettyName}';
        refreshApp(app);
      },
    );
  }

  void _updateStatusLine(String prefix, String line) {
    var status = line.replaceAll('\n', ' ').trim();
    if (status.startsWith('[')) {
      status = status.substring(status.indexOf(']') + 1).trim();
    }
    status = status.substring(0, min(100, status.length));
    if (status.isNotEmpty) {
      ref.read(statusLineProvider.notifier).state = '$prefix : $status';
    }
  }

  Completer<App> getCompleter(String packageName) {
    if (completers.containsKey(packageName)) {
      return completers[packageName]!;
    } else {
      final completer = Completer<App>();
      completers[packageName] = completer;

      return completer;
    }
  }
}

final appsProvider = StateNotifierProvider<AppsNotifier, List<App>>(
  AppsNotifier.new,
);
