import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class ToggleJobBookmark extends HomeEvent {
  final String jobTitle;

  const ToggleJobBookmark(this.jobTitle);

  @override
  List<Object> get props => [jobTitle];
}
