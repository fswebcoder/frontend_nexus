class SingletonSharedPreferences {
  static final SingletonSharedPreferences _singleton = SingletonSharedPreferences._internal();

  factory SingletonSharedPreferences() {
    return _singleton;
  }

  SingletonSharedPreferences._internal();
  static SingletonSharedPreferences get preferences => _singleton;

  String? authToken;

  String? getToken() {
    return authToken;
  }
}
