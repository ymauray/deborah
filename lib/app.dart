import 'package:deborah/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deborah',
      home: YaruTheme(
        child: Material(child: MainLayout()),
      ),
    );
  }
}
