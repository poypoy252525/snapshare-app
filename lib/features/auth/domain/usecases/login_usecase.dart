import 'package:snapshare/features/auth/domain/entities/user.dart';
import 'package:snapshare/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User?> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
