import 'package:deborah/models/app.dart';
import 'package:deborah/providers/apps_provider.dart';
import 'package:deborah/providers/only_show_installed_apps_provider.dart';
import 'package:deborah/providers/only_show_upgradable_apps_provider.dart';
import 'package:deborah/providers/search_query_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredAppsProvider = Provider<List<App>>((ref) {
  final apps = ref.watch(appsProvider);
  final query = ref.watch(searchQueryProvider);
  final onlyShowInstalledApps = ref.watch(onlyShowInstalledAppsProvider);
  final onlyShowUpgradableApps = ref.watch(onlyShowUpgradableAppsProvider);

  var displayedApps = apps;
  if (onlyShowInstalledApps) {
    displayedApps =
        displayedApps.where((app) => app.installedVersion != '').toList();
  }

  if (onlyShowUpgradableApps) {
    displayedApps = displayedApps.where((app) => app.updateAvailable).toList();
  }

  if (query.isEmpty) return displayedApps;

  return displayedApps.where((app) {
    return app.packageName.toLowerCase().contains(query.toLowerCase()) ||
        app.prettyName.toLowerCase().contains(query.toLowerCase()) ||
        app.description.toLowerCase().contains(query.toLowerCase());
  }).toList();
});
