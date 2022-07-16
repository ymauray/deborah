import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/software.dart';

class AppMeta extends StatelessWidget {
  const AppMeta({
    required this.app,
    Key? key,
  }) : super(key: key);

  final Software app;

  Future<Software> getMeta() {
    var completer = Completer<Software>();
    if (app.info != null) {
      completer.complete(app);
    } else {
      var lines = <String>[];
      Process.start('/mnt/data/dev/deb-get/deb-get', ['show', app.packageName])
          .then((process) {
        process.stdout.transform(utf8.decoder).forEach((line) {
          lines.addAll(line.split('\n').map((e) => e.trim()));
        });
        process.exitCode.then((value) {
          app.info = lines
              .skip(1)
              .where(
                (element) =>
                    !element.startsWith('Package') &&
                    !element.startsWith('Summary'),
              )
              .join('\n');
          completer.complete(app);
        });
      });
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 48 + 8 + 48 + 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FutureBuilder<Software>(
              future: getMeta(),
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (app.info != null)
                      Text(
                        app.info ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (app.info == null)
                      Text(
                        'Fetching information...',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (app.installedVersion == '')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text('Install')),
                      ),
                    if (app.installedVersion != '')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text('Uninstall')),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
