import 'package:deborah/models/software.dart';
import 'package:deborah/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshPage extends ConsumerWidget {
  const RefreshPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(softwaresProvider).softwares;

    return Expanded(
      child: Center(
        child: StreamBuilder<Software>(
          stream: ref.read(softwaresProvider).refresh(),
          builder: ((context, snapshot) => Text(
                snapshot.data?.packageName ?? 'Waiting...',
                style: Theme.of(context).textTheme.bodyLarge,
              )),
        ),
      ),
    );
  }
}
