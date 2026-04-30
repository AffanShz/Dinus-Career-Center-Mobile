import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../services/home_service.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService _homeService;

  HomeBloc({HomeService? homeService})
      : _homeService = homeService ?? HomeService(),
        super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<ToggleJobBookmark>(_onToggleJobBookmark);
  }

  void _onToggleJobBookmark(ToggleJobBookmark event, Emitter<HomeState> emit) {
    final updatedJobs = state.recommendedJobs.map((job) {
      if (job.judul == event.jobTitle) {
        return job.copyWith(isBookmarked: !job.isBookmarked);
      }
      return job;
    }).toList();
    emit(state.copyWith(recommendedJobs: updatedJobs));
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final data = await _homeService.fetchHomeData();

      emit(state.copyWith(
        status: HomeStatus.success,
        userName: data['userName'],
        profileCompleteness: data['profileCompleteness'],
        recommendedJobs: data['recommendedJobs'],
        upcomingEvent: data['upcomingEvent'],
      ));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
