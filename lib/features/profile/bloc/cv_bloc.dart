import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/cv_service.dart';
import '../models/profile_model.dart';
import 'cv_event.dart';
import 'cv_state.dart';

class CVBloc extends Bloc<CVEvent, CVState> {
  final CVService _cvService;

  CVBloc({CVService? cvService})
      : _cvService = cvService ?? CVService(),
        super(const CVState()) {
    on<GenerateCV>(_onGenerateCV);
  }

  Future<void> _onGenerateCV(GenerateCV event, Emitter<CVState> emit) async {
    emit(state.copyWith(status: CVStatus.loading));
    try {
      final pdfData = await _cvService.generateCV(
        event.profile,
        event.template,
      );
      emit(state.copyWith(status: CVStatus.success, pdfData: pdfData));
    } catch (e) {
      emit(state.copyWith(status: CVStatus.failure, errorMessage: e.toString()));
    }
  }
}
