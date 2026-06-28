import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/job_model.dart';
import '../services/job_service.dart';

abstract class CompanyJobEvent {}
class FetchCompanyJobs extends CompanyJobEvent {
  final String namaPerusahaan;
  FetchCompanyJobs(this.namaPerusahaan);
}

abstract class CompanyJobState {}
class CompanyJobInitial extends CompanyJobState {}
class CompanyJobLoading extends CompanyJobState {}
class CompanyJobLoaded extends CompanyJobState {
  final List<JobModel> jobs;
  CompanyJobLoaded(this.jobs);
}
class CompanyJobError extends CompanyJobState {
  final String message;
  CompanyJobError(this.message);
}

class CompanyJobBloc extends Bloc<CompanyJobEvent, CompanyJobState> {
  final JobService _jobService;
  CompanyJobBloc({JobService? jobService}) : _jobService = jobService ?? JobService(), super(CompanyJobInitial()) {
    on<FetchCompanyJobs>((event, emit) async {
      emit(CompanyJobLoading());
      try {
        final jobs = await _jobService.fetchJobs(namaPerusahaan: event.namaPerusahaan);
        emit(CompanyJobLoaded(jobs));
      } catch (e) {
        emit(CompanyJobError(e.toString()));
      }
    });
  }
}
