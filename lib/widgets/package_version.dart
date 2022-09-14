import 'package:deborah/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageVersion extends ConsumerWidget {
  const PackageVersion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);

    return packageInfo.when(
      data: (packageInfo) => Text(
        'v${packageInfo.version}',
        style: Theme.of(context).textTheme.labelSmall,
      ),
      error: (_, __) => const Text('Error'),
      loading: () => Text(
        'x.x.x',
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
