import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class GoogleLoginRequested extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object> get props => [email, password, fullName];
}

class OtpVerifyRequested extends AuthEvent {
  final String email;
  final String token;

  const OtpVerifyRequested({
    required this.email,
    required this.token,
  });

  @override
  List<Object> get props => [email, token];
}
