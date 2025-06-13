import 'package:get_it/get_it.dart' as get_it;
import 'package:http/http.dart' as http;
import 'package:maize_guard_admin/features/auth/data/repository/repo_impl.dart';
import 'package:maize_guard_admin/features/auth/domain/repository/auth_repository.dart';
import 'package:maize_guard_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:maize_guard_admin/features/auth/presentation/bloc/register_bloc.dart';
import 'package:maize_guard_admin/features/home/data/repository/home_repo_impl.dart';
import 'package:maize_guard_admin/features/home/domain/repository/home_repository.dart';
import 'package:maize_guard_admin/features/home/domain/usecases/get_expert_usecase.dart';
import 'package:maize_guard_admin/features/home/domain/usecases/update_expert_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/auth/domain/usecases/is_logged_in.dart';
import 'features/auth/domain/usecases/log_out_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_admin_usecase.dart';
import 'features/home/domain/usecases/add_expert_usecase.dart';
import 'features/home/domain/usecases/delete_expert_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

final sl = get_it.GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => http.Client());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // auth
  // repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepoImpl(
        sharedPreferences: sl(),
        networkInfo: sl(),
        client: sl(),
      ));
  // usecases
  sl.registerLazySingleton<IsLoggedInUsecase>(() => IsLoggedInUsecase(
        authRepository: sl(),
      ));
  sl.registerLazySingleton<LogOutUsecase>(() => LogOutUsecase(
        authRepository: sl(),
      ));
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(
        repository: sl(),
      ));
  sl.registerLazySingleton<RegisterAdminUsecase>(() => RegisterAdminUsecase(
        authRepository: sl(),
      ));
  // bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(
        loginUsecase: sl(),
        logOutUsecase: sl(),
        isLoggedInUsecase: sl(),
      ));

  //bloc regiser
  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(registerAdminUsecase: sl()),
  );

  // home
  // repository
  sl.registerLazySingleton<HomeRepository>(
    () =>
        HomeRepoImpl(client: sl(), networkInfo: sl(), sharedPreferences: sl()),
  );
  // usecases
  sl.registerLazySingleton(() => DeleteExpertUsecase(sl()));
  sl.registerLazySingleton(() => AddExpertUsecase(sl()));
  sl.registerLazySingleton(() => GetExpertUsecase(sl()));
  sl.registerLazySingleton(() => UpdateExpertUsecase(sl()));
  // bloc
  sl.registerFactory(() => HomeBloc(
        deleteExpertUsecase: sl(),
        addExpertUsecase: sl(),
        getExpertUsecase: sl(),
        updateExpertUsecase: sl(),
      ));
}
