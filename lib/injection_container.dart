import 'package:get_it/get_it.dart';
import 'package:mudanzas/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// User
import 'features/user/data/datasources/user_remote_data_source.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/domain/usecases/get_profile_usecase.dart';
import 'features/user/domain/usecases/update_profile_usecase.dart';
import 'features/user/presentation/bloc/user_bloc.dart';

// Admin
import 'features/admin/data/datasources/admin_remote_data_source.dart';
import 'features/admin/data/repositories/admin_repository_impl.dart';
import 'features/admin/domain/repositories/admin_repository.dart';
import 'features/admin/domain/usecases/get_users_usecase.dart';
import 'features/admin/domain/usecases/update_user_status_usecase.dart';
import 'features/admin/domain/usecases/update_user_role_usecase.dart';
import 'features/admin/domain/usecases/search_users_usecase.dart';
import 'features/admin/domain/usecases/get_user_by_id_usecase.dart';
import 'features/admin/domain/usecases/update_user_profile_usecase.dart';
import 'features/admin/presentation/bloc/admin_bloc.dart';

// Provider
import 'features/provider/data/datasources/provider_remote_data_source.dart';
import 'features/provider/data/repositories/provider_repository_impl.dart';
import 'features/provider/domain/repositories/provider_repository.dart';
import 'features/provider/domain/usecases/register_provider_usecase.dart';
import 'features/provider/domain/usecases/get_provider_profile_usecase.dart';
import 'features/provider/domain/usecases/update_provider_profile_usecase.dart';
import 'features/provider/domain/usecases/update_provider_availability_usecase.dart';
import 'features/provider/domain/usecases/update_provider_location_usecase.dart';
import 'features/provider/domain/usecases/get_provider_statistics_usecase.dart';
import 'features/provider/domain/usecases/search_providers_location_usecase.dart';
import 'features/provider/presentation/bloc/provider_bloc.dart';

// Moving
import 'features/moving/data/datasources/moving_remote_data_source.dart';
import 'features/moving/data/repositories/moving_repository_impl.dart';
import 'features/moving/domain/repositories/moving_repository.dart';
import 'features/moving/domain/usecases/create_moving_request_usecase.dart';
import 'features/moving/domain/usecases/get_client_requests_usecase.dart';
import 'features/moving/domain/usecases/get_all_requests_usecase.dart';
import 'features/moving/domain/usecases/get_client_movings_usecase.dart';
import 'features/moving/domain/usecases/update_moving_status_usecase.dart';
import 'features/moving/domain/usecases/assign_provider_usecase.dart';
import 'features/moving/presentation/bloc/moving_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core
  sl.registerLazySingleton(() => ApiClient());

  // Auth
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
      ));

  // User
  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Bloc
  sl.registerFactory(() => UserBloc(
        getProfileUseCase: sl(),
        updateProfileUseCase: sl(),
      ));

  // Admin
  // Data sources
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserStatusUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserRoleUseCase(sl()));
  sl.registerLazySingleton(() => SearchUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetUserByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));

  // Bloc
  sl.registerFactory(() => AdminBloc(
        getUsersUseCase: sl(),
        updateUserStatusUseCase: sl(),
        updateUserRoleUseCase: sl(),
        searchUsersUseCase: sl(),
        getUserByIdUseCase: sl(),
        updateUserProfileUseCase: sl(),
      ));

  // Provider
  // Data sources
  sl.registerLazySingleton<ProviderRemoteDataSource>(
    () => ProviderRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProviderRepository>(
    () => ProviderRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterProviderUseCase(sl()));
  sl.registerLazySingleton(() => GetProviderProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProviderProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProviderAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProviderLocationUseCase(sl()));
  sl.registerLazySingleton(() => GetProviderStatisticsUseCase(sl()));
  sl.registerLazySingleton(() => SearchProvidersLocationUseCase(sl()));

  // Bloc
  sl.registerFactory(() => ProviderBloc(
        registerProviderUseCase: sl(),
        getProviderProfileUseCase: sl(),
        updateProviderProfileUseCase: sl(),
        updateProviderAvailabilityUseCase: sl(),
        updateProviderLocationUseCase: sl(),
        getProviderStatisticsUseCase: sl(),
        searchProvidersLocationUseCase: sl(),
      ));

  // Moving
  // Data sources
  sl.registerLazySingleton<MovingRemoteDataSource>(
    () => MovingRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<MovingRepository>(
    () => MovingRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateMovingRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetClientRequestsUseCase(sl()));
  sl.registerLazySingleton(() => GetAllRequestsUseCase(sl()));
  sl.registerLazySingleton(() => GetClientMovingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMovingStatusUseCase(sl()));
  sl.registerLazySingleton(() => AssignProviderUseCase(sl()));

  // Bloc
  sl.registerFactory(() => MovingBloc(
        createMovingRequestUseCase: sl(),
        getClientRequestsUseCase: sl(),
        getAllRequestsUseCase: sl(),
        getClientMovingsUseCase: sl(),
        updateMovingStatusUseCase: sl(),
        assignProviderUseCase: sl(),
      ));
}
