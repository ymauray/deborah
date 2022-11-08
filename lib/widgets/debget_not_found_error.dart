import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class DebgetNotFoundError extends ConsumerWidget {
  const DebgetNotFoundError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Divider(
          thickness: 1,
        ),
        ColoredBox(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Error',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const TextSpan(
                        text: ' : deb-get was not found in PATH. '
                            'Please install deb-get according to the '
                            'instructions at ',
                      ),
                      TextSpan(
                        text: 'https://github.com/wimpysworld/deb-get',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(
                              Uri.parse(
                                'https://github.com/wimpysworld/deb-get',
                              ),
                            );
                          },
                      ),
                      const TextSpan(
                        text: '\nor go to the options page to set the path.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
