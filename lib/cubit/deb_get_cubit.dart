import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/software.dart';

part 'deb_get_state.dart';

const home = String.fromEnvironment('HOME');
const cache = String.fromEnvironment(
  'XDG_CACHE_HOME',
  defaultValue: '$home/.cache',
);

final sourceRegExp = RegExp(r'^\[<img src="\.github/(.*\.png).*\((.*)\)$');
final packageNameRegExp = RegExp(r'^`(.*)`$');
final descriptionRegExp = RegExp(r"<i>(.*)</i>");

enum DebGet {
  applications,
  updates,
  options,
}

class DebGetCubit extends Cubit<DebGetState> {
  DebGetCubit() : super(DebGetInitial());

  final _softwares = <String, Software>{};
  final _controller = StreamController<Software>();

  Stream<Software> loadApplications() {
    if (!_controller.isClosed) {
      Process.start('/mnt/data/dev/deb-get/deb-get', ['csvlist'])
          .then((process) {
        process.stdout.transform(utf8.decoder).forEach(_parseCsvlistOutput);
        process.exitCode.then((value) {
          _controller.close();
          if (value == 0) {
            emit(DebGetLoaded(DebGet.applications, _softwares.values.toList()));
          } else {
            emit(DebGetError());
          }
        });
      });
    }

    return _controller.stream;
  }

  void showApplications() {
    emit(DebGetLoaded(
        DebGet.applications, (state as DebGetLoaded).applications));
  }

  void showUpdates() {
    emit(DebGetLoaded(DebGet.updates, (state as DebGetLoaded).applications));
  }

  void showOptions() {
    emit(DebGetLoaded(DebGet.options, (state as DebGetLoaded).applications));
  }

  void _parseCsvlistOutput(String lines) async {
    var converter = const CsvToListConverter();

    for (var line in lines.split('\n')) {
      var rows = converter.convert(line);
      if (rows.isEmpty) continue;
      var columns = rows[0];
      if (columns.length != 6) continue;
      debugPrint(columns.toString());
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
      _softwares.putIfAbsent(
        packageName,
        () => software,
      );
      _controller.add(software);
    }
  }

  Future<String> getVersion() {
    var version = Completer<String>();

    Process.start('/mnt/data/dev/deb-get/deb-get', ['version']).then((process) {
      process.stdout.transform(utf8.decoder).forEach((line) {
        version.complete(line.trim());
      });
    });

    return version.future;
  }
}
