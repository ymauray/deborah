import 'package:deborah/pages/applications_page.dart';
import 'package:deborah/pages/options_page.dart';
import 'package:deborah/providers.dart';
import 'package:deborah/providers/debget_status_provider.dart';
import 'package:deborah/widgets/left_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenuItem = ref.watch(selectedMenuItemProvider);

    if (ref.read(appsProvider).isEmpty && ref.read(debgetStatusProvider)) {
      ref.read(appsProvider.notifier).refresh();
    }

    return Row(
      children: [
        const LeftMenu(),
        const VerticalDivider(
          thickness: 2,
        ),
        if (selectedMenuItem == SelectedMenuItemEnum.applications)
          const ApplicationsPage(),
        if (selectedMenuItem == SelectedMenuItemEnum.updates)
          const Expanded(
            child: Center(
              child: Text('Updated'),
            ),
          ),
        if (selectedMenuItem == SelectedMenuItemEnum.options)
          const OptionsPage(),
      ],
    );
  }
}
