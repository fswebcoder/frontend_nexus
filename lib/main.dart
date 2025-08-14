import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexus/core/app.dart';
import 'package:nexus/core/styles/app_colors.dart';
import 'package:nexus/core/global/application_settings.dart';
import 'package:nexus/core/global/env/env_debug.dart';
import 'package:nexus/core/global/settings_model.dart';
import 'package:nexus/presentation/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.whiteColor,
      statusBarColor: AppColors.whiteColor,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  final SettingsModel settings = EnvDebug();
  ApplicationSettings().appSettings = settings;
  await serviceLocatorInit();
  runApp(const NexusApp());
}
