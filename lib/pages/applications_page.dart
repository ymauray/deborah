import 'package:deborah/providers.dart';
import 'package:deborah/widgets/search_bar.dart';
import 'package:deborah/widgets/software_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationsPage extends ConsumerWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final softwares = ref.watch(filteredSoftwaresProvider);

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 8, 8),
            child: AbsorbPointer(
              absorbing: !ref.watch(menuEnabledProvider),
              child: Row(
                children: [
                  const Expanded(
                    child: SearchBar(),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        'Check for updates',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: AbsorbPointer(
              absorbing: !ref.watch(menuEnabledProvider),
              child: ListView.separated(
                itemCount: softwares.length,
                itemBuilder: (context, index) {
                  final app = softwares[index];

                  return SoftwareCard(app);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: AbsorbPointer(
              absorbing: !ref.watch(menuEnabledProvider),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Showing ${softwares.length} '
                      "software${softwares.length <= 1 ? '' : 's'}",
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Only show installed apps : '),
                        Switch(
                          value: ref.watch(onlyShowInstalledAppsProvider),
                          onChanged: (value) {
                            ref
                                .read(onlyShowInstalledAppsProvider.notifier)
                                .state = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Only show upgradable apps : '),
                        Switch(
                          value: ref.watch(onlyShowUpgradableAppsProvider),
                          onChanged: (value) {
                            ref
                                .read(onlyShowUpgradableAppsProvider.notifier)
                                .state = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            child: Row(
              children: [
                Text(
                  ref.watch(statusLineProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
