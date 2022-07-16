import 'package:flutter/material.dart';

import '../models/software.dart';

class LoaderIndicator extends StatelessWidget {
  const LoaderIndicator({
    Key? key,
    required Stream<Software>? stream,
  })  : _stream = stream,
        super(key: key);

  final Stream<Software>? _stream;

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
            stream: _stream!,
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
