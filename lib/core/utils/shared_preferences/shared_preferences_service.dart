import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesService {
  Future<void> init();
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);
  Future<bool> setInt(String key, int value);
  int? getInt(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
  bool containsKey(String key);
}

class SharedPreferencesServiceImpl implements SharedPreferencesService {
  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception('SharedPreferences no inicializado. Llame a init() primero.');
    }
    return _prefs!;
  }

  @override
  Future<bool> setString(String key, String value) async {
    return await _instance.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _instance.getString(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    return await _instance.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _instance.getBool(key);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    return await _instance.setInt(key, value);
  }

  @override
  int? getInt(String key) {
    return _instance.getInt(key);
  }

  @override
  Future<bool> remove(String key) async {
    return await _instance.remove(key);
  }

  @override
  Future<bool> clear() async {
    return await _instance.clear();
  }

  @override
  bool containsKey(String key) {
    return _instance.containsKey(key);
  }
}

// Claves constantes para el almacenamiento
class StorageKeys {
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String isLoggedIn = 'is_logged_in';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
}
