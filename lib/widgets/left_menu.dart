import 'package:deborah/providers.dart';
import 'package:deborah/widgets/debget_version.dart';
import 'package:deborah/widgets/menu_button.dart';
import 'package:deborah/widgets/package_version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeftMenu extends ConsumerWidget {
  const LeftMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16).copyWith(bottom: 32),
          child: Column(
            children: [
              Image.asset('assets/resources/deborah_128.png'),
              const SizedBox(height: 8),
              const PackageVersion(),
              const SizedBox(height: 8),
              const DebgetVersion(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const MenuButton(
          label: 'Applications',
          menuItem: SelectedMenuItemEnum.applications,
        ),
        const SizedBox(height: 8),
        const MenuButton(
          label: 'Options',
          menuItem: SelectedMenuItemEnum.options,
        ),
      ],
    );
  }
}
