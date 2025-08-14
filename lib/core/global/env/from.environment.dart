class ConfigDefine{

  static const String domain = String.fromEnvironment("domain",defaultValue:"domain"); // flutter run --dart-define=domain=konecta
  static const String baseURl = String.fromEnvironment("baseURl",defaultValue:"baseUrl"); // flutter run --dart-define=baseURl="https://kuin-dev.onnovacion.com.co/rest/v1.0"

}