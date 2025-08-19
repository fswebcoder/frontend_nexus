import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:nexus/shared/constants/app_constants.dart';

abstract class ToastService {
  void showSuccess(String message, {String? title, IconData? icon, VoidCallback? onTap});
  void showError(String message, {String? title});
  void showWarning(String message, {String? title});
  void showInfo(String message, {String? title});

  void showCustom({
    required String message,
    String? title,
    ToastificationType type = ToastificationType.info,
    Duration autoCloseDuration = const Duration(seconds: 4),
  });
}

class ToastServiceImpl implements ToastService {
  @override
  void showSuccess(String message, {String? title, IconData? icon, VoidCallback? onTap}) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: Text(title ?? 'Éxito'),
      description: Text(message),
      primaryColor: Colors.green,
      backgroundColor: Colors.green.shade600,
      foregroundColor: Colors.white,
      autoCloseDuration: AppConstants.durationMessages,
      showProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  @override
  void showError(String message, {String? title}) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: Text(title ?? 'Error'),
      description: Text(message),
      primaryColor: Colors.red,
      backgroundColor: Colors.red.shade600,
      foregroundColor: Colors.white,
      autoCloseDuration: AppConstants.durationMessages,
      showProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  @override
  void showWarning(String message, {String? title}) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      title: Text(title ?? 'Advertencia'),
      description: Text(message),
      primaryColor: Colors.orange,
      backgroundColor: Colors.orange.shade600,
      foregroundColor: Colors.white,
      autoCloseDuration: AppConstants.durationMessages,
      showProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  @override
  void showInfo(String message, {String? title}) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      title: Text(title ?? 'Información'),
      description: Text(message),
      primaryColor: Colors.blue,
      backgroundColor: Colors.blue.shade600,
      foregroundColor: Colors.white,
      autoCloseDuration: AppConstants.durationMessages,
      showProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  @override
  void showCustom({
    required String message,
    String? title,
    ToastificationType type = ToastificationType.info,
    Duration autoCloseDuration = const Duration(seconds: 4),
  }) {
    final colors = _getColorsForType(type);

    toastification.show(
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(title ?? _getDefaultTitle(type)),
      description: Text(message),
      primaryColor: colors.primary,
      backgroundColor: colors.background,
      foregroundColor: Colors.white,
      autoCloseDuration: autoCloseDuration,
      showProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  ({Color primary, Color background}) _getColorsForType(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return (primary: Colors.green, background: Colors.green.shade600);
      case ToastificationType.error:
        return (primary: Colors.red, background: Colors.red.shade600);
      case ToastificationType.warning:
        return (primary: Colors.orange, background: Colors.orange.shade600);
      case ToastificationType.info:
        return (primary: Colors.blue, background: Colors.blue.shade600);
    }
  }

  String _getDefaultTitle(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return 'Éxito';
      case ToastificationType.error:
        return 'Error';
      case ToastificationType.warning:
        return 'Advertencia';
      case ToastificationType.info:
        return 'Información';
    }
  }
}
