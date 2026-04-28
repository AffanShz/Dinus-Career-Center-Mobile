import 'package:equatable/equatable.dart';
import '../models/event_model.dart';

enum EventStatus { initial, loading, success, failure }

class EventState extends Equatable {
  final EventStatus status;
  final List<EventModel> events;

  const EventState({
    this.status = EventStatus.initial,
    this.events = const [],
  });

  EventState copyWith({
    EventStatus? status,
    List<EventModel>? events,
  }) {
    return EventState(
      status: status ?? this.status,
      events: events ?? this.events,
    );
  }

  @override
  List<Object> get props => [status, events];
}
