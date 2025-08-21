class ConfigDefine {
  static const String domain = String.fromEnvironment("domain", defaultValue: "konecta");
  // ✅ IP para emulador Android: 10.0.2.2 mapea al host (localhost no funciona)
  static const String baseURl = String.fromEnvironment("baseURl", defaultValue: "http://10.0.2.2:8443/api/");
}
