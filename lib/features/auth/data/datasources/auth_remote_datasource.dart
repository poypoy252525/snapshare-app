import 'package:dio/dio.dart';
import 'package:snapshare/core/network/api_constants.dart';
import 'package:snapshare/core/error/exceptions.dart';
import 'package:snapshare/features/auth/data/models/auth_response_model.dart';
import 'package:snapshare/features/auth/data/models/user_model.dart';
import 'package:snapshare/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapshare/injection_container.dart';

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
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.data);
        _currentUser = authResponse.user;

        final prefs = sl<SharedPreferences>();
        await prefs.setString('access_token', authResponse.accessToken);
        await prefs.setString('refresh_token', authResponse.refreshToken);

        return _currentUser;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('non_field_errors')) {
          throw ServerException(data['non_field_errors'][0]);
        } else if (data is Map && data.containsKey('detail')) {
          throw ServerException(data['detail']);
        }
      }
      rethrow;
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
        UserModel? user;
        if (response.data['user'] != null) {
          user = UserModel.fromJson(response.data['user']);
        } else if (response.data['pk'] != null) {
          user = UserModel.fromJson(response.data);
        }

        if (user != null && response.data['access'] != null) {
          final prefs = sl<SharedPreferences>();
          await prefs.setString('access_token', response.data['access']);
          await prefs.setString('refresh_token', response.data['refresh']);
          _currentUser = user;
        }
        return user;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        // Basic error extraction
        if (data is Map) {
          if (data.containsKey('non_field_errors')) {
            throw ServerException(data['non_field_errors'][0]);
          } else if (data.containsKey('email')) {
            throw ServerException(data['email'][0]);
          } else if (data.containsKey('username')) {
            throw ServerException(data['username'][0]);
          } else if (data.containsKey('detail')) {
            throw ServerException(data['detail']);
          }
        }
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    final prefs = sl<SharedPreferences>();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }
}
