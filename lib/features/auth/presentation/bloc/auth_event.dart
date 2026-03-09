part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password1;
  final String password2;
  final String username;

  const SignUpRequested({
    required this.email,
    required this.password1,
    required this.password2,
    required this.username,
  });

  @override
  List<Object?> get props => [email, password1, password2, username];
}

class LogoutRequested extends AuthEvent {}
