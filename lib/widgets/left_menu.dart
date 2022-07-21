import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../cubit/deb_get_cubit.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu({
    Key? key,
    required DebGetState state,
    required Future<String>? version,
    required Future<PackageInfo>? packageInfo,
  })  : _state = state,
        _version = version,
        _packageInfo = packageInfo,
        super(key: key);

  final DebGetState _state;
  final Future<String>? _version;
  final Future<PackageInfo>? _packageInfo;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DebGetCubit>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 32.0),
          child: Column(
            children: [
              Image.asset('assets/resources/deborah_128.png'),
              const SizedBox(height: 8.0),
              FutureBuilder<PackageInfo>(
                builder: (context, future) => Text(
                  "v${future.data?.version ?? "x.x.x"}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                future: _packageInfo,
              ),
              const SizedBox(height: 8.0),
              FutureBuilder<String>(
                builder: (context, future) => Text(
                  "deb-get ${future.data ?? "x.x.x"}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                future: _version,
              ),
            ],
          ),
        ),
        _MenuButton(
          'Applications',
          enabled: _state is! DebGetInitial &&
              !(_state is DebGetLoaded &&
                  (_state as DebGetLoaded).menu == DebGetMenu.lookForUpdates),
          selected: _state is DebGetLoaded &&
              (_state as DebGetLoaded).menu == DebGetMenu.applications,
          onPressed: () => cubit.showApplicationsPanel(),
        ),
        const SizedBox(height: 8.0),
        _MenuButton(
          'Updates',
          enabled: !(_state is DebGetLoaded &&
              (_state as DebGetLoaded).menu == DebGetMenu.lookForUpdates),
          selected: _state is DebGetLoaded &&
              (_state as DebGetLoaded).menu == DebGetMenu.updates,
          onPressed: () => cubit.showUpdatesPanel(),
        ),
        const SizedBox(height: 8.0),
        _MenuButton(
          'Options',
          enabled: !(_state is DebGetLoaded &&
              (_state as DebGetLoaded).menu == DebGetMenu.lookForUpdates),
          selected: _state is DebGetLoaded &&
              (_state as DebGetLoaded).menu == DebGetMenu.options,
          onPressed: () => cubit.showOptions(),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton(
    String label, {
    bool enabled = true,
    bool selected = false,
    VoidCallback? onPressed,
    Key? key,
  })  : _label = label,
        _enabled = enabled,
        _selected = selected,
        _onPressed = onPressed,
        super(key: key);

  final String _label;
  final bool _enabled;
  final bool _selected;
  final VoidCallback? _onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _enabled ? _onPressed : null,
      style: Theme.of(context).textButtonTheme.style!.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => (states.contains(MaterialState.hovered)
                  ? Theme.of(context).colorScheme.primary
                  : _selected && _enabled
                      ? Theme.of(context).colorScheme.primary
                      : null),
            ),
          ),
      child: Text(
        _label,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
