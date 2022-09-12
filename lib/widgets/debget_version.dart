import 'package:deborah/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebgetVersion extends ConsumerWidget {
  const DebgetVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debgetVersion = ref.watch(debgetVersionProvider);

    return debgetVersion.when(
      data: (debgetVersion) => Text(
        "v$debgetVersion",
        style: Theme.of(context).textTheme.labelSmall,
      ),
      error: (_, __) => const Text('Error'),
      loading: () => Text(
        "x.x.x",
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
