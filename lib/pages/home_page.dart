import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/deb_get_cubit.dart';
import '../models/software.dart';
import '../widgets/application_list.dart';
import '../widgets/left_menu.dart';
import '../widgets/loader_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<Software>? _stream;
  Future<String>? _version;

  @override
  initState() {
    super.initState();
    _stream = context.read<DebGetCubit>().loadApplications();
    _version = context.read<DebGetCubit>().getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DebGetCubit, DebGetState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          children: [
            LeftMenu(state: state, version: _version),
            const VerticalDivider(),
            if (state is DebGetInitial)
              Expanded(child: LoaderIndicator(stream: _stream)),
            if (state is DebGetLoaded && state.menu == DebGet.applications)
              Expanded(child: ApplicationList(state)),
          ],
        );
      },
    );
  }
}
