import 'package:my_flutter_project/features/auth/domain/entities/user.dart';
import 'package:my_flutter_project/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User?> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
