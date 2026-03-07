import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_flutter_project/features/auth/domain/entities/user.dart';
import 'package:my_flutter_project/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:my_flutter_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_flutter_project/features/auth/domain/usecases/logout_usecase.dart';
import 'package:my_flutter_project/features/auth/domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await getCurrentUserUseCase();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Login failed: Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        username: event.username,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Signup failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await logoutUseCase();
    emit(Unauthenticated());
  }
}
