import 'package:flutter/material.dart';

import '../models/software.dart';
import '../models/update.dart';

class AppMeta extends StatefulWidget {
  const AppMeta({
    required this.app,
    VoidCallback? onInstall,
    VoidCallback? onRemove,
    VoidCallback? onUpdate,
    bool notInstalled = true,
    this.update,
    super.key,
  })  : _onInstall = onInstall,
        _onRemove = onRemove,
        _onUpdate = onUpdate,
        _notInstalled = notInstalled;

  final Software app;
  final Update? update;
  final VoidCallback? _onInstall;
  final VoidCallback? _onRemove;
  final VoidCallback? _onUpdate;
  final bool _notInstalled;

  @override
  State<AppMeta> createState() => _AppMetaState();
}

class _AppMetaState extends State<AppMeta> {
  Software? app;

  @override
  initState() {
    super.initState();
    app = widget.app;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 48 + 8 + 48 + 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _showMeta(),
          ),
        ),
      ],
    );
  }

  Widget _showMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (app!.info != null)
          Text(
            app!.info ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (app!.info == null)
          Text(
            'Fetching information...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (widget._notInstalled)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              onPressed: widget._onInstall,
              child: const Text('Install'),
            ),
          ),
        if (!widget._notInstalled && widget.update == null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              onPressed: widget._onRemove,
              child: const Text('Remove'),
            ),
          ),
        if (!widget._notInstalled && widget.update != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              onPressed: widget._onUpdate,
              child: Text(
                'Update to version ${widget.update!.updateVersion}',
              ),
            ),
          ),
      ],
    );
  }
}
