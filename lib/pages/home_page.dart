import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../cubit/deb_get_cubit.dart';
import '../widgets/application_loader_indicator.dart';
import '../widgets/left_menu.dart';
import '../widgets/panels/application_list_panel.dart';
import '../widgets/panels/options_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String>? _version;
  Future<PackageInfo>? _packageInfo;

  @override
  void initState() {
    super.initState();
    _version = context.read<DebGetCubit>().getVersion();
    _packageInfo = PackageInfo.fromPlatform();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebGetCubit, DebGetState>(
      builder: (context, state) {
        return Row(
          children: [
            LeftMenu(
              state: state,
              version: _version,
              packageInfo: _packageInfo,
            ),
            const VerticalDivider(),
            if (state is DebGetInitial)
              const Expanded(
                child: ApplicationLoaderIndicator(),
              ),
            if (state is DebGetMenuApplications)
              Expanded(
                child: ApplicationListPanel(
                  state.applications,
                  onRefresh: () {
                    context.read<DebGetCubit>().refreshApplications();
                  },
                ),
              ),
            if (state is DebGetMenuOptions)
              const Expanded(child: OptionsPanel()),
          ],
        );
      },
    );
  }
}

//class HomePage extends StatefulWidget {
//  const HomePage({Key? key}) : super(key: key);

//  @override
//  State<HomePage> createState() => _HomePageState();
//}

//class _HomePageState extends State<HomePage> {
//  Stream<Software>? _stream;
//  Future<String>? _version;
//  Future<PackageInfo>? _packageInfo;

//  @override
//  initState() {
//    super.initState();
//    _stream = context.read<DebGetCubit>().loadApplications();
//    _version = context.read<DebGetCubit>().getVersion();
//    _packageInfo = PackageInfo.fromPlatform();
//  }

//  @override
//  Widget build(BuildContext context) {
//    return BlocConsumer<DebGetCubit, DebGetState>(
//      listener: (context, state) {
//        if (state is DebGetError) {
//          context.read<DebGetCubit>().showApplicationsPanel();
//        }
//      },
//      builder: (context, state) {
//        return Row(
//          children: [
//            LeftMenu(
//              state: state,
//              version: _version,
//              packageInfo: _packageInfo,
//            ),
//            const VerticalDivider(),
//            if (state is DebGetInitial)
//              Expanded(child: LoaderIndicator(stream: _stream)),
//            if (state is DebGetLoaded && state.menu == DebGetMenu.applications)
//              Expanded(child: ApplicationListPanel(state)),
//            if (state is DebGetLoaded &&
//                state.menu == DebGetMenu.lookForUpdates)
//              Expanded(
//                child: state.updates.isEmpty
//                    ? LookForUpdatesPanel(state)
//                    : UpdatesPanel(state),
//              ),
//            if (state is DebGetLoaded && state.menu == DebGetMenu.updates)
//              Expanded(child: UpdatesPanel(state)),
//            if (state is DebGetLoaded && state.menu == DebGetMenu.options)
//              const Expanded(child: OptionsPanel()),
//          ],
//        );
//      },
//    );
//  }
//}
