import 'package:deborah/utils/memory_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

import 'cubit/deb_get_cubit.dart';
import 'pages/home_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => DebGetCubit()),
        Provider<MemoryCache>(
          create: (context) => MemoryCache(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: YaruTheme(
          child: Material(child: HomePage()),
        ),
      ),
    );
  }
}
