import 'package:dcc_mobile/core/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:dcc_mobile/features/auth/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<OtpVerifyRequested>(_onOtpVerifyRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
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
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('invalid login credentials')) {
        emit(
          const AuthFailure(
            'NIM/Password salah, atau akun ini sebelumnya didaftarkan via Google. Silakan coba tombol "Masuk dengan akun dinus.ac.id" di atas.',
          ),
        );
      } else {
        emit(AuthFailure(e.message));
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

  void _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await AuthService.signUpWithEmail(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );

      // If user is returned, but session is null, it typically means
      // email confirmation is required (OTP sent).
      if (response.user != null) {
        // Supabase security feature: if the email already exists,
        // it returns a fake user object with an empty identities array.
        if (response.user!.identities?.isEmpty ?? false) {
          emit(
            const AuthFailure(
              'Email/NIM ini sudah terdaftar. Silakan kembali dan login, atau masuk menggunakan akun Google.',
            ),
          );
          return;
        }

        emit(AuthOtpRequired(event.email));
      } else {
        emit(const AuthFailure('Registration failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onOtpVerifyRequested(
    OtpVerifyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await AuthService.verifyOtp(
        email: event.email,
        token: event.token,
      );

      if (response.session != null) {
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure('Invalid OTP or verification failed.'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
