// ===== 1. SERVICE LOCATOR CORREGIDO =====
// lib/presentation/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nexus/core/network/interceptors/auth_interceptor.dart';
import 'package:nexus/core/network/interceptors/connectivity_interceptor.dart';
import 'package:nexus/core/network/interceptors/logging_interceptor.dart';
import 'package:nexus/core/utils/conection/connectivity_service.dart';
import 'package:nexus/core/utils/shared_preferences/shared_preferences_service.dart';
import 'package:nexus/core/utils/toast/toast_service.dart';
import 'package:nexus/core/global/environment.dart';
import 'dart:io';

// 🎯 Auth Module Dependencies
import 'package:nexus/data/datasources/remote/auth/login_remote_datasource.dart';
import 'package:nexus/domain/repositories/auth/login_repository.dart';
import 'package:nexus/domain/usescases/auth/login_usecase.dart';
import 'package:nexus/insfrastructure/datasources/auth/remote/login_remote_datasource_imp.dart';
import 'package:nexus/insfrastructure/repositories/auth/login_repository_impl.dart';

final GetIt getIt = GetIt.instance;

Future<void> serviceLocatorInit() async {
  // ✅ Connectivity
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerSingleton<ConnectivityService>(ConnectivityServiceImpl(getIt()));

  // ✅ SharedPreferences
  getIt.registerLazySingleton<SharedPreferencesService>(() => SharedPreferencesServiceImpl());
  await getIt<SharedPreferencesService>().init();

  // ✅ Toast
  getIt.registerLazySingleton<ToastService>(() => ToastServiceImpl());

  // ✅ DIO CONFIGURADO CORRECTAMENTE
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();

    // ✅ URL base inteligente
    final baseUrl = _getBaseUrl();
    print('🌐 Configurando Dio con baseURL: $baseUrl');

    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    // ✅ Interceptors en orden correcto
    dio.interceptors.addAll([LoggingInterceptor(), ConnectivityInterceptor(getIt()), AuthInterceptor(getIt())]);

    return dio;
  });

  // ✅ Interceptors individuales
  getIt.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());
  getIt.registerLazySingleton<ConnectivityInterceptor>(() => ConnectivityInterceptor(getIt()));
  getIt.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(getIt()));

  _registerAuthModule();
}

String _getBaseUrl() {
  final envUrl = Environment.baseUrl;
  if (envUrl != null && envUrl.isNotEmpty && envUrl != 'baseUrl') {
    return envUrl.endsWith('/') ? envUrl : '$envUrl/';
  }

  // 2. Fallback basado en plataforma para desarrollo
  if (Platform.isAndroid) {
    return 'http://localhost:8443/api/'; // iOS Simulator
  } else if (Platform.isIOS) {
    return 'http://localhost:8443/api/'; // iOS Simulator
  } else {
    return 'http://localhost:8443/api/'; // Desktop/Web
  }
}

void _registerAuthModule() {
  getIt.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImp());
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(remoteDataSource: getIt<LoginRemoteDataSource>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(loginRepository: getIt<LoginRepository>()));
}
