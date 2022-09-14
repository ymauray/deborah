import 'dart:async';

import 'package:deborah/models/software.dart';
import 'package:deborah/providers.dart';
import 'package:deborah/utils/deb_get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoftwareCard extends ConsumerStatefulWidget {
  const SoftwareCard(Software app, {super.key}) : _app = app;

  final Software _app;

  @override
  ConsumerState<SoftwareCard> createState() => _SoftwareCardState();
}

class _SoftwareCardState extends ConsumerState<SoftwareCard> {
  Completer<Software> completer = Completer<Software>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var installedVersion = '';
    if (widget._app.installedVersion != '') {
      installedVersion = widget._app.installedVersion;
      if (widget._app.updateAvailable) {
        installedVersion += ' (update available)';
      }
    }

    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!completer.isCompleted) {
                final lines = <String>[];
                DebGet.run(
                  ['show', widget._app.packageName],
                  (line) {
                    lines.addAll(line.split('\n').map((e) => e.trim()));
                  },
                  (exitCode) {
                    widget._app.info = lines
                        .skip(1)
                        .where(
                          (element) =>
                              !element.startsWith('Package') &&
                              !element.startsWith('Summary'),
                        )
                        .join('\n');

                    widget._app.installed =
                        !(widget._app.info?.contains('Installed:\tNo') ??
                            false);
                    if (widget._app.installed) {
                      final r = RegExp(r'Installed:\s*(.*)\n');
                      final m = r.firstMatch(widget._app.info ?? '');
                      widget._app.installedVersion = m?.group(1) ?? '';
                    }
                    completer.complete(widget._app);
                  },
                );
              }
              setState(() {
                widget._app.expanded = !widget._app.expanded;
              });
            },
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        widget._app.expanded
                            ? Icons.arrow_drop_down
                            : Icons.arrow_right,
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 8),
                  SizedBox(
                    width: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/icons/${widget._app.icon}',
                        width: 32,
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 8),
                  SizedBox(
                    width: 230,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget._app.prettyName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (widget._app.installedVersion != '')
                            Text(
                              installedVersion,
                              style: widget._app.updateAvailable
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                  : null,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 16,
                      ),
                      child: Text(
                        widget._app.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget._app.expanded)
          IntrinsicHeight(
            child: Row(
              children: [
                const SizedBox(width: 48),
                const VerticalDivider(width: 8),
                const SizedBox(width: 48),
                const VerticalDivider(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: widget._app.info == null
                        ? FutureBuilder<Software>(
                            future: completer.future,
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? _SoftwareMeta(snapshot.data!)
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text('Loading...'),
                                      ],
                                    );
                            },
                          )
                        : _SoftwareMeta(widget._app),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SoftwareMeta extends ConsumerWidget {
  const _SoftwareMeta(Software software) : _software = software;

  final Software _software;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _software.info ?? 'Error loading app info.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Row(
          children: [
            if (!_software.installed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(softwaresProvider.notifier).install(_software);
                  },
                  child: const Text(
                    'Install',
                  ),
                ),
              ),
            if (_software.installed && _software.updateAvailable)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(softwaresProvider.notifier).update(_software);
                    },
                    child: const Text(
                      'Update',
                    ),
                  ),
                ),
              ),
            if (_software.installed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(softwaresProvider.notifier).remove(_software);
                  },
                  child: const Text(
                    'Remove',
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
