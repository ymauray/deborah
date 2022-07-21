import 'package:flutter/material.dart';

import '../../cubit/deb_get_cubit.dart';
import '../../models/software.dart';
import '../../models/update.dart';
import '../app_list_view.dart';

class UpdatesPanel extends StatefulWidget {
  const UpdatesPanel(DebGetLoaded state, {Key? key})
      : _state = state,
        super(key: key);

  final DebGetLoaded _state;

  @override
  State<UpdatesPanel> createState() => _UpdatesPanelState();
}

class _UpdatesPanelState extends State<UpdatesPanel> {
  @override
  Widget build(BuildContext context) {
    var updates = Map<String, Update>.fromIterable(
      widget._state.updates,
      key: (update) => update.packageName,
    );
    var apps = widget._state.updates.isEmpty
        ? <Software>[]
        : widget._state.applications
            .where((app) => updates.containsKey(app.packageName))
            .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(left: 0.0, top: 16.0),
          child: Row(
            children: [
              // Search bar
              Expanded(
                child: Text(
                  "${apps.isNotEmpty ? apps.length : "No"} update${apps.length > 1 ? "s" : ""} available",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (apps.isNotEmpty)
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Update all"),
                ),
            ],
          ),
        ),
        Expanded(
          child: AppListView(
            apps: apps,
            updates: updates,
            onAppSelected: (app) {
              setState(() {
                app.selected = !app.selected;
              });
            },
          ),
        ),
      ],
    );
  }
}
