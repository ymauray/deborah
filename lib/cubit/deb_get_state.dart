part of 'deb_get_cubit.dart';

@immutable
abstract class DebGetState {
  const DebGetState();
}

class DebGetInitial extends DebGetState {}

class DebGetLoaded extends DebGetState {
  const DebGetLoaded(
    this.menu,
    this.applications,
    this.updates,
  );

  final DebGetMenu menu;
  final List<Software> applications;
  final List<Update> updates;
}

class DebGetError extends DebGetState {}
