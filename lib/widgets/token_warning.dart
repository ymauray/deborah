import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenWarning extends ConsumerWidget {
  const TokenWarning({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Divider(
          thickness: 1,
        ),
        Row(
          children: [
            const Icon(
              Icons.warning,
              color: Colors.yellow,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              'Warning',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Text(
              " : it seems you don't have a GitHub API token set. "
              'Visit the options page to set one up.',
            ),
          ],
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
