import 'package:dio/dio.dart';
import 'package:snapshare/core/network/api_constants.dart';
import 'package:snapshare/core/error/exceptions.dart';
import 'package:snapshare/core/services/token_service.dart';
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

  /// Checks stored tokens and returns the current user, or null if unauthenticated.
  Future<User?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final TokenService tokenService;

  AuthRemoteDataSourceImpl({required this.dio, required this.tokenService});

  // ── Login ──────────────────────────────────────────────────────────────────

  @override
  Future<User?> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.data);

        await tokenService.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );

        return authResponse.user;
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
    }
  }

  // ── Sign Up ────────────────────────────────────────────────────────────────

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
        UserModel? user;
        if (response.data['user'] != null) {
          user = UserModel.fromJson(response.data['user']);
        } else if (response.data['pk'] != null) {
          user = UserModel.fromJson(response.data);
        }

        if (user != null &&
            response.data['access'] != null &&
            response.data['refresh'] != null) {
          await tokenService.saveTokens(
            accessToken: response.data['access'] as String,
            refreshToken: response.data['refresh'] as String,
          );
        }
        return user;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
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
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  @override
  Future<void> logout() async {
    await tokenService.clearTokens();
  }

  // ── Get Current User (startup / session restore) ───────────────────────────

  /// Restores session on app launch:
  /// 1. If no token stored → unauthenticated.
  /// 2. Try verifying the access token with the backend.
  /// 3. If valid → fetch and return the user profile.
  /// 4. If invalid (401) → attempt refresh.
  /// 5. If refresh succeeds → save new access token and return user profile.
  /// 6. If refresh also fails → clear tokens, return null.
  @override
  Future<User?> getCurrentUser() async {
    final accessToken = await tokenService.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) return null;

    try {
      // Verify the stored access token
      await dio.post(
        ApiConstants.tokenVerifyEndpoint,
        data: {'token': accessToken},
      );

      // Token is valid – fetch the user profile
      return await _fetchUserProfile(accessToken);
    } on DioException catch (verifyError) {
      if (verifyError.response?.statusCode == 401 ||
          verifyError.response?.statusCode == 400) {
        // Access token expired – try refreshing
        return await _tryRefreshAndGetUser();
      }
      // Network or other error – return null to avoid locking user out
      return null;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<User?> _fetchUserProfile(String accessToken) async {
    try {
      final response = await dio.get(
        ApiConstants.currentUserEndpoint,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<User?> _tryRefreshAndGetUser() async {
    final refreshToken = await tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await dio.post(
        ApiConstants.tokenRefreshEndpoint,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'] as String;
        await tokenService.saveTokens(
          accessToken: newAccessToken,
          refreshToken: refreshToken,
        );
        return await _fetchUserProfile(newAccessToken);
      }
      return null;
    } catch (_) {
      await tokenService.clearTokens();
      return null;
    }
  }
}
