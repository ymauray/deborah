import 'package:flutter/material.dart';

import '../models/software.dart';
import 'app_info.dart';
import 'app_meta.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.index,
    required this.app,
    this.onAppSelected,
    Key? key,
  }) : super(key: key);

  final int index;
  final Software app;
  final void Function(Software app)? onAppSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (index == 0) const Divider(),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (onAppSelected != null) onAppSelected!(app);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInfo(app: app),
                if (app.selected) AppMeta(app: app),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
