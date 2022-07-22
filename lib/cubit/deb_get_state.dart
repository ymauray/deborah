part of 'deb_get_cubit.dart';

@immutable
abstract class DebGetState {
  const DebGetState(
    this.applications,
  );
  final List<Software> applications;
}

class DebGetInitial extends DebGetState {
  DebGetInitial() : super(<Software>[]);
}

class DebGetLoaded extends DebGetState {
  const DebGetLoaded(
    this.menu,
    super.applications,
    this.updates,
  );

  final DebGetMenu menu;
  final List<Update> updates;
}

class DebGetError extends DebGetState {
  const DebGetError(super.applications);
}
