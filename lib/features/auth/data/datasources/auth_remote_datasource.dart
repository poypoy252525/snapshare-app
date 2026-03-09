import 'package:dio/dio.dart';
import 'package:snapshare/core/network/api_constants.dart';
import 'package:snapshare/features/auth/data/models/auth_response_model.dart';
import 'package:snapshare/features/auth/data/models/user_model.dart';
import 'package:snapshare/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
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

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  User? _currentUser;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<User?> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'username': email.split(
            '@',
          )[0], // Backend expects username or email? Using email for now if it's the identifier
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.data);
        _currentUser = authResponse.user;
        // NOTE: In a real app, we should save these tokens to local storage
        return _currentUser;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> signUp({
    required String email,
    required String password1,
    required String password2,
    required String username,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.registrationEndpoint,
        data: {
          'username': username,
          'email': email,
          'password1': password1,
          'password2': password2,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Backend might return user directly or require login after registration
        // Assuming it returns the user object as per common patterns if successful
        if (response.data['user'] != null) {
          return UserModel.fromJson(response.data['user']);
        } else if (response.data['pk'] != null) {
          return UserModel.fromJson(response.data);
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    // Implement server-side logout if needed
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }
}
