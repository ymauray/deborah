import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../cubit/deb_get_cubit.dart';
import '../../utils/memory_cache.dart';
import '../app_list_view.dart';
import '../search_bar.dart';

class ApplicationListPanel extends StatefulWidget {
  const ApplicationListPanel(DebGetLoaded state, {Key? key})
      : _state = state,
        super(key: key);

  final DebGetLoaded _state;

  @override
  State<ApplicationListPanel> createState() => _ApplicationListPanelState();
}

class _ApplicationListPanelState extends State<ApplicationListPanel> {
  var _filter = '';
  MemoryCache? _cache;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cache = context.read<MemoryCache>();
    _filter = _cache!.get('filter', defaultValue: '')!;
  }

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
          initialValue: _filter,
          onChanged: (value) {
            setState(() {
              _filter = value;
              _cache!.set('filter', value);
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
