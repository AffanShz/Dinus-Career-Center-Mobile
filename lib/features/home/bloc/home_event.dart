import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class ToggleJobBookmark extends HomeEvent {
  final String jobId;

  const ToggleJobBookmark(this.jobId);

  @override
  List<Object> get props => [jobId];
}
