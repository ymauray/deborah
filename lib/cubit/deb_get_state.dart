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
  );

  final DebGet menu;
  final List<Software> applications;
}

class DebGetError extends DebGetState {}
