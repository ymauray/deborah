import 'package:deborah/utils/local_storage.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  LocalStorage.init();
  runApp(const App());
}
