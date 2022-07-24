part of 'deb_get_cubit.dart';

@immutable
abstract class DebGetState {
  const DebGetState(
    this.applications,
    this.updates,
  );

  final List<Software> applications;
  final List<Update> updates;
}

class DebGetInitial extends DebGetState {
  DebGetInitial() : super(<Software>[], <Update>[]);
}

class DebGetLoaded extends DebGetState {
  const DebGetLoaded(
    this.menu,
    super.applications,
    super.updates,
  );

  final DebGetMenu menu;
}

class DebGetError extends DebGetState {
  const DebGetError(super.applications, super.updates);
}
