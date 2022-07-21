class Software {
  Software({
    required this.packageName,
    required this.prettyName,
    required this.description,
    required this.icon,
    required this.installedVersion,
    required this.architecture,
  });

  String packageName;
  String prettyName;
  String description;
  String icon;
  String installedVersion;
  String architecture;
  String? info;
  bool selected = false;

  @override
  String toString() {
    return 'Software(packageName: $packageName, prettyName: $prettyName, '
        'description: $description, icon: $icon)';
  }
}
