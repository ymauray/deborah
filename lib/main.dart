import 'package:deborah/app.dart';
import 'package:deborah/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await LocalStorage.init();
  runApp(const ProviderScope(child: App()));
}
