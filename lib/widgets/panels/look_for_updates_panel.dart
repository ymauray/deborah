import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../cubit/deb_get_cubit.dart';

class LookForUpdatesPanel extends StatefulWidget {
  const LookForUpdatesPanel(DebGetLoaded state, {Key? key})
      : _state = state,
        super(key: key);

  // ignore: unused_field
  final DebGetLoaded _state;

  @override
  State<LookForUpdatesPanel> createState() => _LookForUpdatesPanelState();
}

class _LookForUpdatesPanelState extends State<LookForUpdatesPanel> {
  Stream<String>? _stream;

  @override
  void initState() {
    super.initState();
    _stream = context.read<DebGetCubit>().loadUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Looking for updates',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          StreamBuilder<String>(
            stream: _stream!,
            builder: (context, snapshot) {
              return Text(snapshot.data ?? "");
            },
          ),
        ],
      ),
    );
  }
}
