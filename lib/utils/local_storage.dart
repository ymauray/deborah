import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const debgetpathKey = 'debgetpath';
  static const showTokenWarningKey = 'showTokenWarning';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static T get<T>(String key, T defaultValue) {
    final keys = _prefs?.getKeys();
    final value = _prefs?.get(key);

    return (value ?? defaultValue) as T;
  }

  static void set<T>(String key, T value) {
    if (value is String) {
      _prefs?.setString(key, value);
    } else if (value is int) {
      _prefs?.setInt(key, value);
    } else if (value is double) {
      _prefs?.setDouble(key, value);
    } else if (value is bool) {
      _prefs?.setBool(key, value);
    } else {
      _prefs?.setString(key, value.toString());
    }
  }
}
