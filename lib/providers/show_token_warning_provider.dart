import 'package:deborah/utils/local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showTokenWarningProvider = StateProvider<bool>((ref) {
  final value = LocalStorage.get(LocalStorage.showTokenWarningKey, true);

  return value;
});
