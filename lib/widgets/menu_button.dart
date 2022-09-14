import 'package:deborah/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuButton extends ConsumerWidget {
  const MenuButton({
    required String label,
    required SelectedMenuItemEnum menuItem,
    super.key,
  })  : _label = label,
        _menuItem = menuItem;

  final String _label;
  final SelectedMenuItemEnum _menuItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuEnabled = ref.watch(menuEnabledProvider);
    final selected = ref.watch(selectedMenuItemProvider) == _menuItem;

    return TextButton(
      onPressed: menuEnabled
          ? () {
              ref.read(selectedMenuItemProvider.notifier).state = _menuItem;
            }
          : null,
      style: Theme.of(context).textButtonTheme.style!.copyWith(
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => states.contains(MaterialState.hovered)
                  ? Theme.of(context).colorScheme.onPrimary
                  : selected && menuEnabled
                      ? Theme.of(context).colorScheme.onPrimary
                      : null,
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => states.contains(MaterialState.hovered)
                  ? Theme.of(context).colorScheme.primary
                  : selected && menuEnabled
                      ? Theme.of(context).colorScheme.primary
                      : null,
            ),
          ),
      child: Text(
        _label,
      ),
    );
  }
}
