import 'package:deborah/providers.dart';
import 'package:deborah/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationsPage extends ConsumerWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var softwares = ref.watch(filteredSoftwaresProvider);

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 8.0, 8.8),
            child: Row(
              children: [
                const Expanded(
                  child: SearchBar(),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                OutlinedButton(
                  onPressed: () {
                    ref.read(selectedMenuItemProvider.notifier).state =
                        SelectedMenuItemEnum.refresh;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'Refresh',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: softwares.length,
              itemBuilder: (context, index) {
                final app = softwares[index];

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      debugPrint("Tapped");
                    },
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 48,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_right,
                              ),
                            ),
                          ),
                          const VerticalDivider(width: 8.0),
                          SizedBox(
                            width: 48.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/icons/${app.icon}",
                                width: 32.0,
                              ),
                            ),
                          ),
                          const VerticalDivider(width: 8.0),
                          SizedBox(
                            width: 230.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    app.prettyName,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  if (app.installedVersion != '')
                                    Text(
                                      app.installedVersion,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const VerticalDivider(width: 8.0),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 16.0,
                              ),
                              child: Text(
                                app.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}
