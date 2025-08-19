import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
        final hasConnection = await _checkInternetConnection(result);
        _connectionStreamController.add(hasConnection);
      },
      onError: (error) {
        // Solo log de errores críticos
        debugPrint('ConnectivityService: Error crítico - $error');
      },
    );

    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      final hasConnection = await _checkInternetConnection(result);
      _connectionStreamController.add(hasConnection);
    } catch (e) {
      debugPrint('ConnectivityService: Error inicial - $e');
    }
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectionStreamController.stream;
  }

  @override
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      return await _checkInternetConnection(result);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasInternetConnection() async {
    return await isConnected;
  }

  Future<bool> _checkInternetConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      return false;
    }

    if (kIsWeb) {
      return await _checkInternetConnectionWeb();
    } else {
      return await _checkInternetConnectionMobile();
    }
  }

  Future<bool> _checkInternetConnectionWeb() async {
    final List<String> testUrls = [
      'https://www.google.com/generate_204',
      'https://www.cloudflare.com/cdn-cgi/trace',
      'https://httpbin.org/get',
      'https://jsonplaceholder.typicode.com/posts/1',
    ];

    for (final url in testUrls) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
        final hasInternet = response.statusCode >= 200 && response.statusCode < 400;

        if (hasInternet) {
          return true;
        }
      } catch (e) {
        continue;
      }
    }
    return false;
  }

  Future<bool> _checkInternetConnectionMobile() async {
    final List<String> testHosts = [
      'google.com',
      'cloudflare.com',
      '8.8.8.8', // DNS de Google
      'microsoft.com',
    ];

    for (final host in testHosts) {
      try {
        final result = await InternetAddress.lookup(host).timeout(const Duration(seconds: 10));
        final hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

        if (hasInternet) {
          return true;
        }
      } on SocketException catch (_) {
        continue;
      } on TimeoutException catch (_) {
        continue;
      } catch (_) {
        continue;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStreamController.close();
  }
}
