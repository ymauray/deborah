import 'dart:async';

import 'package:flutter/material.dart';

import '../models/software.dart';
import '../models/update.dart';
import '../utils/deb_get.dart';
import 'app_info.dart';
import 'app_meta.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    required this.index,
    required this.app,
    this.update,
    this.onAppSelected,
    Key? key,
  }) : super(key: key);

  final int index;
  final Software app;
  final Update? update;
  final void Function(Software app)? onAppSelected;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  void initState() {
    super.initState();
  }

  bool notInstalled = false;

  Future<Software> getMeta() {
    var completer = Completer<Software>();
    if (widget.app.info != null || !widget.app.selected) {
      completer.complete(widget.app);
    } else {
      var lines = <String>[];
      DebGet.run(
        ['show', widget.app.packageName],
        (line) {
          lines.addAll(line.split('\n').map((e) => e.trim()));
        },
        (exitCode) {
          widget.app.info = lines
              .skip(1)
              .where(
                (element) =>
                    !element.startsWith('Package') &&
                    !element.startsWith('Summary'),
              )
              .join('\n');

          notInstalled = widget.app.info?.contains("Installed:\tNo") ?? false;
          if (!notInstalled) {
            var r = RegExp(r'Installed:\s*(.*)\n');
            var m = r.firstMatch(widget.app.info ?? '');
            widget.app.installedVersion = m?.group(1) ?? '';
          }
          completer.complete(widget.app);
        },
      );
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.index == 0) const Divider(),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (widget.onAppSelected != null) {
                widget.onAppSelected!(widget.app);
              }
            },
            child: FutureBuilder<Software>(
              future: getMeta(),
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInfo(app: widget.app),
                    if (widget.app.selected)
                      AppMeta(
                        app: widget.app,
                        update: widget.update,
                        notInstalled: notInstalled,
                        onInstall: () async {
                          await installApp(context, widget.app);
                          setState(() {
                            widget.app.info = null;
                            widget.app.installedVersion = '';
                          });
                        },
                        onRemove: () async {
                          await installApp(
                            context,
                            widget.app,
                            remove: true,
                          );
                          setState(() {
                            widget.app.info = null;
                            widget.app.installedVersion = '';
                          });
                        },
                        onUpdate: () async {
                          await installApp(context, widget.app);
                          setState(() {});
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Future<void> installApp(
    BuildContext context,
    Software app, {
    bool remove = false,
  }) async {
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(
        context,
        rootNavigator: true,
      ).context,
    );

    return showGeneralDialog<void>(
      context: context,
      barrierColor: const Color(0xC0000000),
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      pageBuilder: (context, animation, secondaryAnimation) => themes.wrap(
        _ProcessFeedback(
          "${remove ? 'Removing' : 'Installing'} ${app.packageName}",
          [(remove ? 'remove' : 'install'), app.packageName],
          elevate: true,
        ),
      ),
    );
  }
}

class _ProcessFeedback extends StatefulWidget {
  const _ProcessFeedback(
    String label,
    List<String> arguments, {
    bool elevate = false,
    Key? key,
  })  : _label = label,
        _arguments = arguments,
        _elevate = elevate,
        super(key: key);

  final String _label;
  final List<String> _arguments;
  final bool _elevate;

  @override
  State<_ProcessFeedback> createState() => _ProcessFeedbackState();
}

class _ProcessFeedbackState extends State<_ProcessFeedback> {
  @override
  Widget build(BuildContext context) {
    var controller = StreamController<String>();
    var stream = controller.stream;

    DebGet.run(
      widget._arguments,
      (line) {
        for (var part in line.split("\n")) {
          if (part.isNotEmpty) {
            controller.add(part);
          }
        }
      },
      (exitCode) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
      elevate: widget._elevate,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget._label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          StreamBuilder<String>(
            stream: stream,
            builder: (context, snapshot) {
              return Text(snapshot.data ?? "");
            },
          ),
        ],
      ),
    );
  }
}
