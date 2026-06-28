import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/job_application_service.dart';

abstract class JobApplicationEvent {}
class SubmitApplication extends JobApplicationEvent {
  final String lowonganId;
  final File? pasFoto;
  final File? cv;
  final File? portofolioFile;
  final String? portofolioLink;
  final File? transkipNilai;
  final File? suratLamaran;

  SubmitApplication({
    required this.lowonganId,
    this.pasFoto,
    this.cv,
    this.portofolioFile,
    this.portofolioLink,
    this.transkipNilai,
    this.suratLamaran,
  });
}
class CancelApplication extends JobApplicationEvent {
  final String lowonganId;
  CancelApplication(this.lowonganId);
}

abstract class JobApplicationState {}
class JobApplicationInitial extends JobApplicationState {}
class JobApplicationLoading extends JobApplicationState {}
class JobApplicationSuccess extends JobApplicationState {
  final String message;
  JobApplicationSuccess(this.message);
}
class JobApplicationFailure extends JobApplicationState {
  final String error;
  JobApplicationFailure(this.error);
}

class JobApplicationBloc extends Bloc<JobApplicationEvent, JobApplicationState> {
  final JobApplicationService _service;
  JobApplicationBloc({JobApplicationService? service}) : _service = service ?? JobApplicationService(), super(JobApplicationInitial()) {
    on<SubmitApplication>((event, emit) async {
      emit(JobApplicationLoading());
      final result = await _service.submitApplication(
        lowonganId: event.lowonganId,
        pasFoto: event.pasFoto,
        cv: event.cv,
        portofolioFile: event.portofolioFile,
        portofolioLink: event.portofolioLink,
        transkipNilai: event.transkipNilai,
        suratLamaran: event.suratLamaran,
      );
      switch (result) {
        case ApplicationResult.success:
          emit(JobApplicationSuccess('Lamaran berhasil dikirim'));
          break;
        case ApplicationResult.alreadyApplied:
          emit(JobApplicationFailure('Anda sudah pernah melamar lowongan ini.'));
          break;
        case ApplicationResult.notLoggedIn:
          emit(JobApplicationFailure('Sesi Anda berakhir. Silakan masuk kembali.'));
          break;
        case ApplicationResult.failure:
          emit(JobApplicationFailure('Gagal mengirim lamaran. Pastikan profil lengkap atau periksa koneksi Anda.'));
          break;
      }
    });

    on<CancelApplication>((event, emit) async {
      emit(JobApplicationLoading());
      final success = await _service.cancelApplication(event.lowonganId);
      if (success) {
        emit(JobApplicationSuccess('Lamaran berhasil dibatalkan.'));
      } else {
        emit(JobApplicationFailure('Gagal membatalkan lamaran.'));
      }
    });
  }
}
