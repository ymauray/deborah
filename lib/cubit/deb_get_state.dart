part of 'deb_get_cubit.dart';

@immutable
abstract class DebGetState {
  const DebGetState(
    this.applications,
    this.updates,
    this.menuEnabled,
  );

  final List<Software> applications;
  final List<Update> updates;
  final bool menuEnabled;
}

class DebGetInitial extends DebGetState {
  DebGetInitial(List<Update> updates)
      : super(
          <Software>[],
          updates,
          false,
        );
}

@Deprecated('Use new states instead')
class DebGetLoaded extends DebGetState {
  const DebGetLoaded(
    this.menu,
    List<Software> applications,
    List<Update> updates,
  ) : super(
          applications,
          updates,
          false,
        );

  final DebGetMenu menu;
}

class DebGetMenuApplications extends DebGetState {
  const DebGetMenuApplications(
    List<Software> applications,
    List<Update> updates,
  ) : super(
          applications,
          updates,
          true,
        );
}

class DebGetMenuUpdates extends DebGetState {
  const DebGetMenuUpdates(
    List<Software> applications,
    List<Update> updates,
  ) : super(
          applications,
          updates,
          true,
        );
}

class DebGetMenuOptions extends DebGetState {
  const DebGetMenuOptions(
    List<Software> applications,
    List<Update> updates,
  ) : super(
          applications,
          updates,
          true,
        );
}

class DebGetError extends DebGetState {
  const DebGetError(
    List<Software> applications,
    List<Update> updates,
  ) : super(
          applications,
          updates,
          false,
        );
}
