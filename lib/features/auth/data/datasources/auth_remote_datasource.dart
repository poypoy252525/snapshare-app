import 'package:snapshare/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
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

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  User? _currentUser;

  @override
  Future<User?> login({required String email, required String password}) async {
    // Mocking a successful login
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      id: '1',
      email: email,
      firstName: 'Test',
      lastName: 'User',
      username: 'testuser',
    );
    return _currentUser;
  }

  @override
  Future<User?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
  }) async {
    // Mocking a successful signup
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      id: '1',
      email: email,
      firstName: firstName,
      lastName: lastName,
      username: username,
    );
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }
}
