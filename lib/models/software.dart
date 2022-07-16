class Software {
  Software({
    required this.packageName,
    required this.prettyName,
    required this.description,
    required this.icon,
    required this.installedVersion,
    required this.architecture,
  });
  final String packageName;
  final String prettyName;
  final String description;
  final String icon;
  final String installedVersion;
  final String architecture;

  bool selected = false;
  String? info;

  @override
  String toString() {
    return 'Software(packageName: $packageName, prettyName: $prettyName, '
        'description: $description, icon: $icon)';
  }
}
