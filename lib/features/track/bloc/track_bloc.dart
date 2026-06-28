import 'package:flutter_bloc/flutter_bloc.dart';
import 'track_event.dart';
import 'track_state.dart';
import '../services/track_service.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final TrackService _trackService;

  TrackBloc({TrackService? trackService})
      : _trackService = trackService ?? TrackService(),
        super(const TrackState()) {
    on<LoadApplications>(_onLoadApplications);
    on<ChangeFilter>(_onChangeFilter);
  }

  Future<void> _onLoadApplications(
    LoadApplications event,
    Emitter<TrackState> emit,
  ) async {
    emit(state.copyWith(status: TrackStatus.loading, selectedFilter: event.filter));
    try {
      final applications = await _trackService.fetchApplications(filter: event.filter);
      emit(state.copyWith(status: TrackStatus.success, applications: applications));
    } catch (_) {
      emit(state.copyWith(status: TrackStatus.failure));
    }
  }

  Future<void> _onChangeFilter(ChangeFilter event, Emitter<TrackState> emit) async {
    add(LoadApplications(filter: event.filter));
  }
}
