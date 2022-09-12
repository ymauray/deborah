import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'main_layout.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: YaruTheme(
        child: Material(child: MainLayout()),
      ),
    );
  }
}
