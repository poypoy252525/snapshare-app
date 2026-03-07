import 'package:my_flutter_project/features/auth/domain/entities/user.dart';
import 'package:my_flutter_project/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<User?> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
  }) {
    return repository.signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      username: username,
    );
  }
}
