import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:snapshare/core/services/token_service.dart';
import 'package:snapshare/features/posts/data/datasources/post_remote_datasource.dart';
import 'package:snapshare/features/posts/data/repositories/post_repository_impl.dart';
import 'package:snapshare/features/posts/domain/repositories/post_repository.dart';
import 'package:snapshare/features/posts/domain/usecases/get_posts.dart';
import 'package:snapshare/features/posts/domain/usecases/create_post.dart';
import 'package:snapshare/features/posts/presentation/bloc/post_bloc.dart';
import 'package:snapshare/features/navigation/presentation/cubit/navigation_cubit.dart';
import 'package:snapshare/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:snapshare/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:snapshare/features/auth/domain/repositories/auth_repository.dart';
import 'package:snapshare/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:snapshare/features/auth/domain/usecases/login_usecase.dart';
import 'package:snapshare/features/auth/domain/usecases/logout_usecase.dart';
import 'package:snapshare/features/auth/domain/usecases/signup_usecase.dart';
import 'package:snapshare/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snapshare/core/network/api_constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Core ────────────────────────────────────────────────────────────────────

  // Secure storage (encrypted on device)
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  // Token service – wraps secure storage with typed helpers
  sl.registerLazySingleton(() => TokenService(sl()));

  // SharedPreferences – kept registered in case other parts of the app need it
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Dio – with automatic JWT refresh interceptor
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // A separate Dio instance just for refresh calls (no interceptors to avoid
    // infinite loops when the refresh request itself fails).
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final path = options.path;

          // Skip token for these specific endpoints
          final isPublic = path.contains(ApiConstants.loginEndpoint) ||
              path.contains(ApiConstants.registrationEndpoint) ||
              path.contains(ApiConstants.tokenRefreshEndpoint) ||
              path.contains(ApiConstants.tokenVerifyEndpoint);

          if (!isPublic) {
            final token = await sl<TokenService>().getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Only attempt refresh on 401 from protected endpoints
          if (error.response?.statusCode != 401) {
            return handler.next(error);
          }

          // Avoid refresh loops on the refresh endpoint itself
          final path = error.requestOptions.path;
          if (path.contains(ApiConstants.tokenRefreshEndpoint) ||
              path.contains(ApiConstants.loginEndpoint)) {
            return handler.next(error);
          }

          try {
            final refreshToken = await sl<TokenService>().getRefreshToken();
            if (refreshToken == null) {
              return handler.next(error);
            }

            // Call refresh endpoint
            final refreshResponse = await refreshDio.post(
              ApiConstants.tokenRefreshEndpoint,
              data: {'refresh': refreshToken},
            );

            final newAccessToken = refreshResponse.data['access'] as String;

            // Persist new access token (refresh token stays valid)
            await sl<TokenService>().saveTokens(
              accessToken: newAccessToken,
              refreshToken: refreshToken,
            );

            // Retry the original request with new token
            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await dio.fetch(opts);
            return handler.resolve(retryResponse);
          } catch (_) {
            // Refresh failed – clear tokens so auth check redirects to login
            await sl<TokenService>().clearTokens();
            return handler.next(error);
          }
        },
      ),
    );

    return dio;
  });

  // ── Features – Navigation ────────────────────────────────────────────────────
  sl.registerLazySingleton(() => NavigationCubit());

  // ── Features – Authentication ────────────────────────────────────────────────
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUserUseCase: sl(),
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl(), tokenService: sl()),
  );

  // ── Features – Posts ─────────────────────────────────────────────────────────
  sl.registerFactory(() => PostBloc(getPosts: sl(), createPost: sl()));

  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => CreatePost(sl()));

  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(dio: sl()),
  );
}
