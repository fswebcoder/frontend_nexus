import 'package:nexus/core/global/env/from.environment.dart';

class Environment {
  static String? baseUrl = _getValidBaseUrl();
  static String? dominio = ConfigDefine.domain;

  static String? _getValidBaseUrl() {
    final url = ConfigDefine.baseURl;
    if (url == 'baseUrl' || url.isEmpty) {
      return null;
    }
    return url;
  }
}
