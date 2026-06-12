import 'package:equatable/equatable.dart';
import '../models/event_model.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends EventEvent {}

class ToggleBookmarkEvent extends EventEvent {
  final int eventId;

  const ToggleBookmarkEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}
