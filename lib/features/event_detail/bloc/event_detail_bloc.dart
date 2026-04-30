import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_detail_event.dart';
import 'event_detail_state.dart';
import '../services/event_detail_service.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventDetailService _eventDetailService;

  EventDetailBloc({required EventDetailService eventDetailService})
      : _eventDetailService = eventDetailService,
        super(EventDetailInitial()) {
    on<LoadEventDetail>(_onLoadEventDetail);
  }

  Future<void> _onLoadEventDetail(
    LoadEventDetail event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(EventDetailLoading());
    try {
      final eventDetail = await _eventDetailService.getEventDetail(event.eventId);
      emit(EventDetailLoaded(eventDetail));
    } catch (e) {
      emit(EventDetailError(e.toString()));
    }
  }
}
