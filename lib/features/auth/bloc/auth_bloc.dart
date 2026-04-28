import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Simulate API call for standard login
      await Future.delayed(const Duration(seconds: 1));
      
      // Add real authentication logic here later
      if (event.username.isNotEmpty && event.password.isNotEmpty) {
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure('Username and password cannot be empty'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onGoogleLoginRequested(GoogleLoginRequested event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    // try {
    //   await _googleSignIn.authenticate();
    //   
    //   // Here you would usually send the Google account details to your backend
    //   // For example: final GoogleSignInAuthentication auth = await account.authentication;
    //   emit(AuthSuccess());
    // } catch (e) {
    //   emit(AuthFailure(e.toString()));
    // }
  }
}
