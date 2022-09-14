import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SelectedMenuItemEnum {
  applications,
  updates,
  options,
  refresh,
}

/// This provider is used to store the selected menu item
final selectedMenuItemProvider = StateProvider<SelectedMenuItemEnum>(
  (ref) => SelectedMenuItemEnum.applications,
);
