import 'package:equatable/equatable.dart';

abstract class TrackEvent extends Equatable {
  const TrackEvent();

  @override
  List<Object> get props => [];
}

class LoadApplications extends TrackEvent {
  final String filter;

  const LoadApplications({this.filter = 'Semua (12)'});

  @override
  List<Object> get props => [filter];
}

class ChangeFilter extends TrackEvent {
  final String filter;

  const ChangeFilter(this.filter);

  @override
  List<Object> get props => [filter];
}
