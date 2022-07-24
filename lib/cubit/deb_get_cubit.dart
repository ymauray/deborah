import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/software.dart';
import '../models/update.dart';
import '../utils/deb_get.dart';

part 'deb_get_state.dart';

const home = String.fromEnvironment('HOME');
const cache = String.fromEnvironment(
  'XDG_CACHE_HOME',
  defaultValue: '$home/.cache',
);

final updateAvailableRegExp =
    RegExp(r"(.*) \((.*)\) has an update pending. (.*) is available.");

enum DebGetMenu {
  applications,
  lookForUpdates,
  updates,
  options,
}

class DebGetCubit extends Cubit<DebGetState> {
  DebGetCubit() : super(DebGetInitial());

  final _applications = <String, Software>{};
  final _applicationsController = StreamController<Software>();
  final _updates = <Update>[];
  StreamController<String>? _updatesController;

  Stream<Software> loadApplications() {
    if (!_applicationsController.isClosed) {
      DebGet.run(['csvlist'], _parseCsvlistOutput, (exitCode) {
        _applicationsController.close();
        if (exitCode == 0) {
          emit(
            DebGetLoaded(
              DebGetMenu.applications,
              _applications.values.toList(),
              state.updates,
            ),
          );
        } else {
          emit(DebGetError(state.applications, state.updates));
        }
      });
    }

    return _applicationsController.stream;
  }

  void showApplicationsPanel() {
    emit(
      DebGetLoaded(
        DebGetMenu.applications,
        state.applications,
        state.updates,
      ),
    );
  }

  void showUpdatesPanel() {
    emit(DebGetLoaded(
      state.updates.isEmpty ? DebGetMenu.lookForUpdates : DebGetMenu.updates,
      state.applications,
      state.updates,
    ));
  }

  void refreshUpdates() {
    emit(DebGetLoaded(
      DebGetMenu.lookForUpdates,
      state.applications,
      const [],
    ));
  }

  void showOptions() {
    emit(
      DebGetLoaded(
        DebGetMenu.options,
        state.applications,
        state.updates,
      ),
    );
  }

  void _parseCsvlistOutput(String lines) async {
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
      _applications.putIfAbsent(
        packageName,
        () => software,
      );
      _applicationsController.add(software);
    }
  }

  Future<String> getVersion() {
    var version = Completer<String>();

    DebGet.run(
      ['version'],
      (line) {
        version.complete(line.trim());
      },
      null,
    );

    return version.future;
  }

  Stream<String>? loadUpdates() {
    if (_updatesController == null || _updatesController!.isClosed) {
      _updatesController = StreamController<String>();
    }

    DebGet.run(
      ['update'],
      _parseUpdatesOutput,
      (exitCode) {
        _updatesController!.close();
        if (exitCode == 0) {
          emit(
            DebGetLoaded(
              DebGetMenu.updates,
              state.applications,
              _updates,
            ),
          );
        } else {
          emit(DebGetError(state.applications, state.updates));
        }
      },
      elevate: true,
    );

    return _updatesController!.stream;
  }

  void _parseUpdatesOutput(String lines) async {
    for (var line in lines.split('\n')) {
      if (line.isNotEmpty) {
        if (line.startsWith("  ") && line.contains("32m")) {
          line = line.substring(15);
          if (updateAvailableRegExp.hasMatch(line)) {
            var match = updateAvailableRegExp.allMatches(line).first;
            var packageName = match.group(1);
            var installedVersion = match.group(2);
            var updateVersion = match.group(3);
            var update = Update(
              packageName: packageName!,
              installedVersion: installedVersion!,
              updateVersion: updateVersion!,
            );
            _updates.add(update);
          }
        }
        _updatesController!.add(line);
      }
    }
  }
}
