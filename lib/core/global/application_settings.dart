import 'settings_model.dart';

class ApplicationSettings {
  static ApplicationSettings? _singleton;
  SettingsModel? appSettings;

  ApplicationSettings._();

  factory ApplicationSettings() {
    _singleton ??= ApplicationSettings._();
    return _singleton!;
  }
}
