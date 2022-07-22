class MemoryCache {
  MemoryCache();

  final Map<String, dynamic> _cache = {};

  bool containsKey(String key) {
    return _cache.containsKey(key);
  }

  T? get<T>(String key, {T? defaultValue}) {
    return containsKey(key) ? _cache[key] as T : defaultValue;
  }

  void set(String key, dynamic value) {
    _cache[key] = value;
  }
}
