import 'dart:io' show Platform;

import 'package:deborah/providers/show_token_warning_provider.dart';
import 'package:deborah/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptionsPage extends ConsumerWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();
    final controller = TextEditingController(
      text: LocalStorage.get(
        LocalStorage.debgetpathKey,
        '',
      ),
    );

    final env = Platform.environment;
    final token = env['DEBGET_TOKEN'];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8).copyWith(left: 0, top: 16),
            child: Text(
              'Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.always,
                        name: 'debgetpath',
                        controller: controller,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'deb-get path '
                              '(including executable name, '
                              'leave empty for default)',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: controller.clear,
                          ),
                        ),
                        onChanged: (value) {
                          LocalStorage.set(
                            LocalStorage.debgetpathKey,
                            value ?? '',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8).copyWith(left: 0),
            child: Text(
              'GitHub API Rate Limits',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if ((token ?? '') == '')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'deb-get uses the GitHub REST API for some functionality '
                  'when applications are provided via GitHub Releases  and for '
                  'unauthenticated interactions this API is rate-limited to 60 '
                  'calls per hour per source (IP Address). This is vital for '
                  'keeping the API responsive and available to all users, but '
                  'can be inconvenient if you have a lot of GitHub releases '
                  'being handled by deb-get (or need to update several times '
                  'in a short period to test your contribution) and will '
                  'result in, for example, temporary failures to be able to '
                  'upgrade or install applications via GitHub Releases .',
                ),
                const SizedBox(height: 8),
                const Text(
                  'If you have a GitHub account you can authenticate your '
                  'GitHub API usage to increase your rate-limit to 5000 '
                  'requests per hour per authenticated user. To do this you '
                  'will need to use a Personal Access Token (PAT). Once you '
                  'have created a token within GitHub (or identified an '
                  'appropriate existing token) you should insert it into an '
                  'environment variable (DEBGET_TOKEN) for deb-get to pick up '
                  'and use to authenticate to the GitHub API.',
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  thickness: 1,
                ),
                Row(
                  children: [
                    const Text(
                      'Show warning on apps page if token is not set',
                    ),
                    Switch(
                      value: ref.watch(showTokenWarningProvider),
                      onChanged: (value) {
                        LocalStorage.set(
                          LocalStorage.showTokenWarningKey,
                          value,
                        );
                        ref.read(showTokenWarningProvider.notifier).state =
                            value;
                      },
                    ),
                  ],
                ),
              ],
            ),
          if ((token ?? '') != '') const Text('Your GitHub API token is set.'),
        ],
      ),
    );
  }
}
