import 'package:dcc_mobile/core/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/features/auth/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
  }

  void _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await AuthService.signInWithEmail(
        email: event.username,
        password: event.password,
      );

      if (response.session != null) {
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure('Login failed. Please check your credentials.'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      appLog('DEBUG: AuthBloc calling AuthService.signInWithGoogle()');
      final response = await AuthService.signInWithGoogle();

      if (response == null) {
        appLog('DEBUG: AuthBloc received null response (user cancelled)');
        emit(AuthInitial());
        return;
      }

      if (response.session != null) {
        appLog('DEBUG: AuthBloc success: Session created');
        emit(AuthSuccess());
      } else {
        appLog('DEBUG: AuthBloc failure: No session in response');
        emit(const AuthFailure('Google Sign-In failed. Please try again.'));
      }
    } catch (e, stackTrace) {
      appLog('DEBUG: AuthBloc caught error: $e');
      appLog('DEBUG: StackTrace: $stackTrace');
      emit(AuthFailure(e.toString()));
    }
  }
}
