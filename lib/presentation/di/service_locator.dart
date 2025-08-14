import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nexus/core/network/dio_client.dart';
import 'package:nexus/core/network/interceptors/auth_interceptor.dart';
import 'package:nexus/core/network/interceptors/connectivity_interceptor.dart';
import 'package:nexus/core/network/interceptors/logging_interceptor.dart';
import 'package:nexus/core/utils/conection/connectivity_service.dart';
import 'package:nexus/core/utils/shared_preferences/shared_preferences_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> serviceLocatorInit() async {
  // Core dependencies
  getIt.registerLazySingleton(() => Connectivity());

  // Services - Cambio a Singleton para inicialización inmediata
  getIt.registerSingleton<ConnectivityService>(ConnectivityServiceImpl(getIt()));

  getIt.registerLazySingleton<SharedPreferencesService>(() => SharedPreferencesServiceImpl());

  await getIt<SharedPreferencesService>().init();

  final connectivityService = getIt<ConnectivityService>();
  await connectivityService.isConnected;

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();

    dio.options.baseUrl = 'https://localhost:/api/'; // Cambia por tu API
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);

    dio.options.headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};

    return dio;
  });

  // Interceptors
  getIt.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(getIt()));

  getIt.registerLazySingleton<ConnectivityInterceptor>(() => ConnectivityInterceptor(getIt()));

  getIt.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());

  // Dio Client con interceptors
  getIt.registerLazySingleton<DioClient>(() {
    final dio = getIt<Dio>();

    // Agregar interceptors en orden
    dio.interceptors.addAll([
      getIt<ConnectivityInterceptor>(), // Verificar conectividad
      getIt<AuthInterceptor>(), // Manejar autenticación
      getIt<LoggingInterceptor>(), // Logging (solo en debug)
    ]);

    return DioClient(dio);
  });
}
