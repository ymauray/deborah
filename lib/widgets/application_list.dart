import 'package:flutter/material.dart';

import '../cubit/deb_get_cubit.dart';
import 'app_list_view.dart';
import 'search_bar.dart';

class ApplicationList extends StatefulWidget {
  const ApplicationList(DebGetLoaded state, {Key? key})
      : _state = state,
        super(key: key);

  final DebGetLoaded _state;

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  var _filter = '';

  @override
  Widget build(BuildContext context) {
    var apps = widget._state.applications
        .where(
          (app) =>
              app.prettyName.toLowerCase().contains(
                    _filter.toLowerCase(),
                  ) ||
              app.description.toLowerCase().contains(
                    _filter.toLowerCase(),
                  ) ||
              app.packageName.toLowerCase().contains(
                    _filter.toLowerCase(),
                  ),
        )
        .toList();

    return Column(
      children: [
        SearchBar(
          onChanged: (value) {
            setState(() {
              _filter = value;
            });
          },
        ),
        Expanded(
          child: AppListView(
            apps: apps,
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
