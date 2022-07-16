import 'package:flutter/material.dart';

import '../models/software.dart';
import 'app_card.dart';

class AppListView extends StatelessWidget {
  const AppListView({
    required this.apps,
    this.onAppSelected,
    Key? key,
  }) : super(key: key);

  final List<Software> apps;
  final void Function(Software app)? onAppSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.custom(
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          final app = apps[index];
          return AppCard(
            index: index,
            app: app,
            onAppSelected: onAppSelected,
          );
        },
        childCount: apps.length,
      ),
    );
  }
}
