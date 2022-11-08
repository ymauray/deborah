import 'dart:convert';
import 'dart:io';

import 'package:deborah/utils/local_storage.dart';

class DebGet {
  static void run(
    List<String> arguments,
    void Function(String line) action,
    void Function(int exitCode)? exit, {
    bool elevate = false,
  }) {
    var debget = LocalStorage.get(LocalStorage.debgetpathKey, 'deb-get');
    if (debget.isEmpty) {
      debget = 'deb-get';
    }
    Process.start(
      elevate ? 'pkexec' : debget,
      [if (elevate) debget, ...arguments],
    ).then((process) {
      process.stdout.transform(utf8.decoder).forEach(action);
      if (exit != null) process.exitCode.then(exit);
    }).catchError((_) {
      if (exit != null) exit(-9999);
    });
  }
}
