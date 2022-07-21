import 'dart:convert';
import 'dart:io';

class DebGet {
  static const String debget = '/mnt/data/dev/deb-get/deb-get';

  static void run(
    List<String> arguments,
    void Function(String line) action,
    void Function(int exitCode)? exit, {
    bool elevate = false,
  }) {
    Process.start(
      elevate ? 'pkexec' : debget,
      [if (elevate) debget, ...arguments],
    ).then((process) {
      process.stdout.transform(utf8.decoder).forEach(action);
      if (exit != null) process.exitCode.then(exit);
    });
  }
}
