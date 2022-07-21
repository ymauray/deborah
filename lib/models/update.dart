class Update {
  const Update({
    required String packageName,
    required String installedVersion,
    required String updateVersion,
  })  : _packageName = packageName,
        _installedVersion = installedVersion,
        _updateVersion = updateVersion;

  final String _packageName;
  final String _installedVersion;
  final String _updateVersion;

  String get packageName => _packageName;
  String get installedVersion => _installedVersion;
  String get updateVersion => _updateVersion;
}
