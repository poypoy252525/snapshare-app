import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:snapshare/features/posts/data/datasources/post_remote_datasource.dart';
import 'package:snapshare/features/posts/data/repositories/post_repository_impl.dart';
import 'package:snapshare/features/posts/domain/repositories/post_repository.dart';
import 'package:snapshare/features/posts/domain/usecases/get_posts.dart';
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
  // Core
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    ),
  );

  // Features - Navigation
  sl.registerLazySingleton(() => NavigationCubit());

  // Features - Authentication
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUserUseCase: sl(),
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // Features - Posts
  // Bloc
  sl.registerFactory(() => PostBloc(getPosts: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPosts(sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(dio: sl()),
  );
}
