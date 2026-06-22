import 'package:flutter_bloc/flutter_bloc.dart';
import 'job_event.dart';
import 'job_state.dart';
import '../services/job_service.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final JobService _jobService;

  JobBloc({JobService? jobService})
    : _jobService = jobService ?? JobService(),
      super(const JobState()) {
    on<LoadJobs>(_onLoadJobs);
    on<ChangeCategory>(_onChangeCategory);
    on<SearchJobs>(_onSearchJobs);
    on<ApplyJobSuccess>(_onApplyJobSuccess);
    on<ApplyAdvancedFilter>(_onApplyAdvancedFilter);
  }

  void _onApplyJobSuccess(ApplyJobSuccess event, Emitter<JobState> emit) {
    final updatedJobs = state.jobs.map((job) {
      if (job.id == event.jobId) {
        return job.copyWith(isApplied: true);
      }
      return job;
    }).toList();
    emit(state.copyWith(jobs: updatedJobs));
  }

  Future<void> _onLoadJobs(LoadJobs event, Emitter<JobState> emit) async {
    emit(
      state.copyWith(
        status: JobStatus.loading,
        selectedCategory: event.category,
        searchQuery: event.query,
        selectedSektor: event.sektor,
        selectedJurusan: event.jurusan,
        selectedLokasi: event.lokasi,
      ),
    );
    try {
      final jobs = await _jobService.fetchJobs(
        category: event.category,
        query: event.query,
        sektor: event.sektor,
        jurusan: event.jurusan,
        lokasi: event.lokasi,
      );
      emit(state.copyWith(status: JobStatus.success, jobs: jobs));
    } catch (_) {
      emit(state.copyWith(status: JobStatus.failure));
    }
  }

  Future<void> _onChangeCategory(
    ChangeCategory event,
    Emitter<JobState> emit,
  ) async {
    add(LoadJobs(
      category: event.category,
      query: state.searchQuery,
      sektor: state.selectedSektor,
      jurusan: state.selectedJurusan,
      lokasi: state.selectedLokasi,
    ));
  }

  Future<void> _onSearchJobs(SearchJobs event, Emitter<JobState> emit) async {
    add(LoadJobs(
      category: state.selectedCategory,
      query: event.query,
      sektor: state.selectedSektor,
      jurusan: state.selectedJurusan,
      lokasi: state.selectedLokasi,
    ));
  }

  Future<void> _onApplyAdvancedFilter(ApplyAdvancedFilter event, Emitter<JobState> emit) async {
    add(LoadJobs(
      category: state.selectedCategory,
      query: state.searchQuery,
      sektor: event.sektor,
      jurusan: event.jurusan,
      lokasi: event.lokasi,
    ));
  }
}
