import 'package:deborah/models/software.dart';
import 'package:deborah/providers/only_show_installed_apps_provider.dart';
import 'package:deborah/providers/only_show_upgradable_apps_provider.dart';
import 'package:deborah/providers/search_query_provider.dart';
import 'package:deborah/providers/softwares_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredSoftwaresProvider = Provider<List<Software>>((ref) {
  final softwares = ref.watch(softwaresProvider);
  final query = ref.watch(searchQueryProvider);
  final onlyShowInstalledApps = ref.watch(onlyShowInstalledAppsProvider);
  final onlyShowUpgradableApps = ref.watch(onlyShowUpgradableAppsProvider);

  var apps = softwares;
  if (onlyShowInstalledApps) {
    apps = apps.where((app) => app.installedVersion != '').toList();
  }

  if (onlyShowUpgradableApps) {
    apps = apps.where((app) => app.updateAvailable).toList();
  }

  if (query.isEmpty) return apps;

  return apps.where((app) {
    return app.packageName.contains(query) ||
        app.prettyName.contains(query) ||
        app.description.contains(query);
  }).toList();
});
