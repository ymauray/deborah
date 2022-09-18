import 'package:deborah/models/app.dart';
import 'package:deborah/providers.dart';
import 'package:deborah/utils/deb_get.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AppCard extends ConsumerStatefulWidget {
  const AppCard(App app, {super.key}) : _app = app;

  final App _app;

  @override
  ConsumerState<AppCard> createState() => _AppCardState();
}

class _AppCardState extends ConsumerState<AppCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final completer =
        ref.read(appsProvider.notifier).getCompleter(widget._app.packageName);

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
                    lines.addAll(
                      line.split('\n').where((e) => !e.trim().startsWith('[')),
                    );
                  },
                  (exitCode) {
                    widget._app
                      ..info = lines
                          .where((line) => line.isNotEmpty)
                          .skip(1)
                          .where(
                            (line) => !line.startsWith('Summary'),
                          )
                          .join('\n')
                      ..installed =
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
                    width: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: (installedVersion != '')
                          ? Icon(
                              Icons.check_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : Container(),
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
                        ? FutureBuilder<App>(
                            future: completer.future,
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? _AppMeta(snapshot.data!)
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text('Loading...'),
                                      ],
                                    );
                            },
                          )
                        : _AppMeta(widget._app),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AppMeta extends ConsumerWidget {
  const _AppMeta(App app) : _app = app;

  final App _app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataTable(
          headingRowHeight: 0,
          horizontalMargin: 0,
          dataTextStyle: Theme.of(context).textTheme.bodySmall,
          columns: const [
            DataColumn(label: Text('Package')),
            DataColumn(label: Text('Summary')),
          ],
          rows: (_app.info ?? '')
              .split('\n')
              .where((line) => line.isNotEmpty)
              .map<DataRow>((line) {
            final chunks = line.split('\t');
            final package = Text(chunks[0]);
            final value = chunks.length == 2 ? chunks[1] : '';
            final summary = value.startsWith('http')
                ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: value,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse(Uri.encodeFull(value)));
                            },
                        ),
                      ],
                    ),
                  )
                : (chunks[0] == 'Repository:')
                    ? SelectableText(value)
                    : Text(value);

            return DataRow(
              cells: [
                DataCell(package),
                DataCell(summary),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (!_app.installed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(appsProvider.notifier).install(_app);
                  },
                  child: const Text(
                    'Install',
                  ),
                ),
              ),
            if (_app.installed && _app.updateAvailable)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(appsProvider.notifier).update(_app);
                    },
                    child: const Text(
                      'Update',
                    ),
                  ),
                ),
              ),
            if (_app.installed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(appsProvider.notifier).remove(_app);
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
