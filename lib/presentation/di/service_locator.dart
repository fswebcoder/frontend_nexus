import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nexus/core/network/dio_client.dart';
import 'package:nexus/core/network/interceptors/auth_interceptor.dart';
import 'package:nexus/core/network/interceptors/connectivity_interceptor.dart';
import 'package:nexus/core/network/interceptors/logging_interceptor.dart';
import 'package:nexus/core/utils/conection/connectivity_service.dart';
import 'package:nexus/core/utils/shared_preferences/shared_preferences_service.dart';
import 'package:nexus/core/utils/toast/toast_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> serviceLocatorInit() async {
  getIt.registerLazySingleton(() => Connectivity());

  getIt.registerSingleton<ConnectivityService>(ConnectivityServiceImpl(getIt()));

  getIt.registerLazySingleton<SharedPreferencesService>(() => SharedPreferencesServiceImpl());

  getIt.registerLazySingleton<ToastService>(() => ToastServiceImpl());

  await getIt<SharedPreferencesService>().init();

  // El servicio de conectividad se inicializará automáticamente cuando sea necesario

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();

    dio.options.baseUrl = 'https://localhost:8080/api/'; // Cambia por tu API
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    dio.options.headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};

    return dio;
  });

  getIt.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(getIt()));

  getIt.registerLazySingleton<ConnectivityInterceptor>(() => ConnectivityInterceptor(getIt()));

  getIt.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());

  getIt.registerLazySingleton<DioClient>(() {
    final dio = getIt<Dio>();

    dio.interceptors.addAll([getIt<ConnectivityInterceptor>(), getIt<AuthInterceptor>(), getIt<LoggingInterceptor>()]);

    return DioClient(dio);
  });
}
