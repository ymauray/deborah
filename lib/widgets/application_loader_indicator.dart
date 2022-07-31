import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubit/deb_get_cubit.dart';
import '../models/software.dart';

class ApplicationLoaderIndicator extends StatefulWidget {
  const ApplicationLoaderIndicator({
    Key? key,
  }) : super(key: key);

  @override
  State<ApplicationLoaderIndicator> createState() =>
      _ApplicationLoaderIndicatorState();
}

class _ApplicationLoaderIndicatorState
    extends State<ApplicationLoaderIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Loading availbale applications',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          StreamBuilder<Software>(
            stream: context.read<DebGetCubit>().loadApplications(),
            builder: (context, snapshot) {
              return Text(
                snapshot.data?.packageName ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              );
            },
          ),
        ],
      ),
    );
  }
}
