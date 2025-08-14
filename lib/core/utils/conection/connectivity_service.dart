import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

abstract class ConnectivityService {
  Stream<bool> get onConnectivityChanged;
  Future<bool> get isConnected;
  Future<bool> hasInternetConnection();
  void dispose();
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;
  late StreamController<bool> _connectionStreamController;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityServiceImpl(this._connectivity) {
    _connectionStreamController = StreamController<bool>.broadcast();
    _init();
  }

  void _init() {
    if (kDebugMode) {
      print('ConnectivityService: Inicializando...');
    }

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        if (kDebugMode) {
          print('ConnectivityService: Cambio detectado: $results');
        }

        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
        final hasConnection = await _checkInternetConnection(result);

        if (kDebugMode) {
          print('ConnectivityService: Resultado final: ${hasConnection ? "CONECTADO" : "DESCONECTADO"}');
        }

        _connectionStreamController.add(hasConnection);
      },
      onError: (error) {
        if (kDebugMode) {
          print('ConnectivityService: Error en stream: $error');
        }
      },
    );

    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    try {
      if (kDebugMode) {
        print('ConnectivityService: Verificando estado inicial...');
      }

      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      final hasConnection = await _checkInternetConnection(result);

      if (kDebugMode) {
        print('ConnectivityService: Estado inicial: ${hasConnection ? "CONECTADO" : "DESCONECTADO"}');
      }
      _connectionStreamController.add(hasConnection);
    } catch (e) {
      if (kDebugMode) {
        print('ConnectivityService: Error verificando estado inicial: $e');
      }
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    if (kDebugMode) {
      print('ConnectivityService: Stream solicitado');
    }
    return _connectionStreamController.stream;
  }

  @override
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      return await _checkInternetConnection(result);
    } catch (e) {
      if (kDebugMode) {
        print('ConnectivityService: Error verificando conexión: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> hasInternetConnection() async {
    return await isConnected;
  }

  Future<bool> _checkInternetConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      if (kDebugMode) {
        print('ConnectivityService: Sin conectividad de red');
      }
      return false;
    }

    if (kDebugMode) {
      print('ConnectivityService: Conectividad detectada ($result), verificando internet...');
    }

    try {
      final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));

      final hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (kDebugMode) {
        print('ConnectivityService: Verificación de internet: ${hasInternet ? "EXITOSA" : "FALLIDA"}');
      }

      return hasInternet;
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('ConnectivityService: SocketException - Sin internet: $e');
      }
      return false;
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print('ConnectivityService: TimeoutException - Sin internet: $e');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('ConnectivityService: Error inesperado: $e');
      }
      return false;
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('ConnectivityService: Disposing...');
    }
    _connectivitySubscription?.cancel();
    _connectionStreamController.close();
  }
}
