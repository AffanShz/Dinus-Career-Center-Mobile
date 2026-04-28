import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_event.dart';
import 'event_state.dart';
import '../services/event_service.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventService _eventService;

  EventBloc({EventService? eventService})
      : _eventService = eventService ?? EventService(),
        super(const EventState()) {
    on<LoadEvents>(_onLoadEvents);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(state.copyWith(status: EventStatus.loading));
    try {
      final events = await _eventService.fetchEvents();
      emit(state.copyWith(status: EventStatus.success, events: events));
    } catch (_) {
      emit(state.copyWith(status: EventStatus.failure));
    }
  }

  void _onToggleBookmark(ToggleBookmarkEvent event, Emitter<EventState> emit) {
    final updatedEvents = state.events.map((e) {
      if (e.id == event.eventId) {
        return e.copyWith(isBookmarked: !e.isBookmarked);
      }
      return e;
    }).toList();
    emit(state.copyWith(events: updatedEvents));
  }
}
