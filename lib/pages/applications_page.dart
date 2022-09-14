import 'package:deborah/models/software.dart';
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
          const _SearchBar(),
          _AppsList(softwares: softwares),
          const Divider(
            thickness: 2,
          ),
          /* Bottom bar */
          _BottomBar(softwares: softwares),
          const Divider(
            thickness: 2,
          ),
          const _StatusLine(),
        ],
      ),
    );
  }
}

class _StatusLine extends ConsumerWidget {
  const _StatusLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final absorbing = !ref.watch(menuEnabledProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ref.watch(statusLineProvider),
            ),
          ),
          if (absorbing)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.softwares,
  });

  final List<Software> softwares;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final absorbing = !ref.watch(menuEnabledProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: AbsorbPointer(
        absorbing: absorbing,
        child: Stack(
          children: [
            Row(
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
            if (absorbing)
              Positioned.fill(
                child: ColoredBox(
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(0.6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AppsList extends ConsumerWidget {
  const _AppsList({
    required this.softwares,
  });

  final List<Software> softwares;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final absorbing = !ref.watch(menuEnabledProvider);

    return Expanded(
      child: Stack(
        children: [
          AbsorbPointer(
            absorbing: absorbing,
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
          if (absorbing)
            Positioned.fill(
              child: ColoredBox(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.6),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchBar extends ConsumerWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final absorbing = !ref.watch(menuEnabledProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 8, 8),
          child: AbsorbPointer(
            absorbing: absorbing,
            child: Row(
              children: [
                const Expanded(
                  child: SearchBar(),
                ),
                const SizedBox(
                  width: 8,
                ),
                OutlinedButton(
                  onPressed: () {
                    ref.read(softwaresProvider.notifier).checkUpdates();
                  },
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
        if (absorbing)
          Positioned.fill(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.background.withOpacity(0.6),
            ),
          ),
      ],
    );
  }
}
