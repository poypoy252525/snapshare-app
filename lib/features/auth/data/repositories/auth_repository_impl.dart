import 'package:snapshare/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:snapshare/features/auth/domain/entities/user.dart';
import 'package:snapshare/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User?> login({required String email, required String password}) {
    return remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<User?> signUp({
    required String email,
    required String password1,
    required String password2,
    required String username,
  }) {
    return remoteDataSource.signUp(
      email: email,
      password1: password1,
      password2: password2,
      username: username,
    );
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<User?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}
