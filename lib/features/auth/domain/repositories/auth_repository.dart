import 'package:my_flutter_project/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login({required String email, required String password});

  Future<User?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();
}
