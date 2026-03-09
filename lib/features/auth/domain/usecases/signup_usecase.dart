import 'package:snapshare/features/auth/domain/entities/user.dart';
import 'package:snapshare/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<User?> call({
    required String email,
    required String password1,
    required String password2,
    required String username,
  }) {
    return repository.signUp(
      email: email,
      password1: password1,
      password2: password2,
      username: username,
    );
  }
}
