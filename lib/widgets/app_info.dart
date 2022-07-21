import 'package:flutter/material.dart';

import '../models/software.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({
    required this.app,
    Key? key,
  }) : super(key: key);

  final Software app;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 48.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: app.selected
                  ? const Icon(Icons.arrow_drop_down)
                  : const Icon(Icons.arrow_right),
            ),
          ),
          const VerticalDivider(width: 8.0),
          SizedBox(
            width: 48.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/icons/${app.icon}",
                width: 32.0,
              ),
            ),
          ),
          const VerticalDivider(width: 8.0),
          SizedBox(
            width: 230.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    app.prettyName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (app.installedVersion != '')
                    Text(
                      app.installedVersion,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 8.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 16.0,
              ),
              child: Text(
                app.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
