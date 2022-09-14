class Software {
  Software({
    required this.packageName,
    required this.prettyName,
    required this.description,
    required this.icon,
    required this.installedVersion,
    required this.architecture,
    this.info,
    this.expanded = false,
    this.installed = false,
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

  Software clone() => Software(
        packageName: packageName,
        prettyName: prettyName,
        description: description,
        icon: icon,
        installedVersion: installedVersion,
        architecture: architecture,
        info: info,
        expanded: expanded,
        installed: installed,
      );

  Software copyWith({
    String? packageName,
    String? prettyName,
    String? description,
    String? icon,
    String? installedVersion,
    String? architecture,
    String? info,
    bool? expanded,
    bool? installed,
  }) =>
      Software(
        packageName: packageName ?? this.packageName,
        prettyName: prettyName ?? this.prettyName,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        installedVersion: installedVersion ?? this.installedVersion,
        architecture: architecture ?? this.architecture,
        info: info ?? this.info,
        expanded: expanded ?? this.expanded,
        installed: installed ?? this.installed,
      );

  @override
  String toString() {
    return 'Software('
        'packageName: $packageName, prettyName: $prettyName, '
        'description: $description, icon: $icon, '
        'installedVersion: $installedVersion, architecture: $architecture, '
        'info: $info, expanded: $expanded, installed: $installed)';
  }
}
