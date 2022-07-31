import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/software.dart';
import '../../utils/memory_cache.dart';
import '../app_list_view.dart';
import '../search_bar.dart';

class ApplicationListPanel extends StatefulWidget {
  const ApplicationListPanel(
    List<Software> apps, {
    VoidCallback? onRefresh,
    Key? key,
  })  : _apps = apps,
        _onRefresh = onRefresh,
        super(key: key);

  final List<Software> _apps;
  final VoidCallback? _onRefresh;

  @override
  State<ApplicationListPanel> createState() => _ApplicationListPanelState();
}

class _ApplicationListPanelState extends State<ApplicationListPanel> {
  var _filter = '';
  MemoryCache? _cache;

  @override
  void initState() {
    super.initState();
    _cache = context.read<MemoryCache>();
    _filter = _cache!.get('filter', defaultValue: '')!;
  }

  @override
  Widget build(BuildContext context) {
    var apps = widget._apps
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
          onRefresh: widget._onRefresh,
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
