import 'package:get_it/get_it.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post_repository.dart';
import 'features/posts/domain/usecases/get_posts.dart';
import 'features/posts/presentation/bloc/post_bloc.dart';
import 'features/navigation/presentation/cubit/navigation_cubit.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
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
    () => AuthRemoteDataSourceImpl(),
  );

  // Features - Posts
  // Bloc
  sl.registerFactory(() => PostBloc(getPosts: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPosts(sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl());
}
