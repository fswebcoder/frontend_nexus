import 'settings_model.dart';
import '../styles/app_colors.dart';
import '../../shared/models/branding_model.dart';

class ApplicationSettings {
  static ApplicationSettings? _singleton;
  SettingsModel? appSettings;
  BrandingModel? _branding;

  ApplicationSettings._();

  factory ApplicationSettings() {
    _singleton ??= ApplicationSettings._();
    return _singleton!;
  }

  BrandingModel? get branding => _branding;

  void setBranding(BrandingModel branding) {
    _branding = branding;
    AppColors.setCustomColors(
      primaryColor: branding.primaryColor,
      secondaryColor: branding.secondaryColor,
      accentColor: branding.tertiaryColor,
    );
  }

  void resetBranding() {
    _branding = null;
    AppColors.resetColors();
  }
}
