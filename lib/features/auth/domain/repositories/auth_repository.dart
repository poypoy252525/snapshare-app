import 'package:snapshare/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login({required String email, required String password});

  Future<User?> signUp({
    required String email,
    required String password1,
    required String password2,
    required String username,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();
}
