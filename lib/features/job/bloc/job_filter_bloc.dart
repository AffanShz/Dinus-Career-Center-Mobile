import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/job_service.dart';

abstract class JobFilterEvent {}
class FetchFilterOptions extends JobFilterEvent {}

abstract class JobFilterState {}
class JobFilterInitial extends JobFilterState {}
class JobFilterLoading extends JobFilterState {}
class JobFilterLoaded extends JobFilterState {
  final List<String> sektorOptions;
  final List<String> jurusanOptions;
  final List<String> lokasiOptions;
  JobFilterLoaded(this.sektorOptions, this.jurusanOptions, this.lokasiOptions);
}
class JobFilterError extends JobFilterState {
  final String error;
  JobFilterError(this.error);
}

class JobFilterBloc extends Bloc<JobFilterEvent, JobFilterState> {
  final JobService _service;
  JobFilterBloc({JobService? service}) : _service = service ?? JobService(), super(JobFilterInitial()) {
    on<FetchFilterOptions>((event, emit) async {
      emit(JobFilterLoading());
      try {
        final options = await _service.fetchFilterOptions();
        emit(JobFilterLoaded(
          options['sektor'] ?? [],
          options['jurusan'] ?? [],
          options['lokasi'] ?? [],
        ));
      } catch (e) {
        emit(JobFilterError(e.toString()));
      }
    });
  }
}
