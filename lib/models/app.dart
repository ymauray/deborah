class App {
  App({
    required this.packageName,
    required this.prettyName,
    required this.description,
    required this.icon,
    required this.installedVersion,
    required this.architecture,
    this.info,
    this.expanded = false,
    this.installed = false,
    this.updateAvailable = false,
  });

  String packageName;
  String prettyName;
  String description;
  String icon;
  String installedVersion;
  String architecture;
  String? info;
  bool expanded;
  bool installed;
  bool updateAvailable;

  App clone() => App(
        packageName: packageName,
        prettyName: prettyName,
        description: description,
        icon: icon,
        installedVersion: installedVersion,
        architecture: architecture,
        info: info,
        expanded: expanded,
        installed: installed,
        updateAvailable: updateAvailable,
      );

  App copyWith({
    String? packageName,
    String? prettyName,
    String? description,
    String? icon,
    String? installedVersion,
    String? architecture,
    String? info,
    bool? expanded,
    bool? installed,
    bool? updateAvailable,
  }) =>
      App(
        packageName: packageName ?? this.packageName,
        prettyName: prettyName ?? this.prettyName,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        installedVersion: installedVersion ?? this.installedVersion,
        architecture: architecture ?? this.architecture,
        info: info ?? this.info,
        expanded: expanded ?? this.expanded,
        installed: installed ?? this.installed,
        updateAvailable: updateAvailable ?? this.updateAvailable,
      );

  @override
  String toString() {
    return 'App('
        'packageName: $packageName, prettyName: $prettyName, '
        'description: $description, icon: $icon, '
        'installedVersion: $installedVersion, architecture: $architecture, '
        'info: $info, expanded: $expanded, installed: $installed, '
        'updateAvailable: $updateAvailable)';
  }
}
