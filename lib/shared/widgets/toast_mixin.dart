import 'package:flutter/material.dart';
import 'package:nexus/core/utils/toast/toast_service.dart';
import 'package:nexus/presentation/di/service_locator.dart';
import 'package:toastification/toastification.dart';

mixin ToastMixin<T extends StatefulWidget> on State<T> {
  ToastService get _toastService => getIt<ToastService>();

  void showSuccessToast(String message, {String? title, IconData? icon}) {
    _toastService.showSuccess(message, title: title, icon: icon);
  }

  void showErrorToast(String message, {String? title}) {
    _toastService.showError(message, title: title);
  }

  void showWarningToast(String message, {String? title}) {
    _toastService.showWarning(message, title: title);
  }

  void showInfoToast(String message, {String? title}) {
    _toastService.showInfo(message, title: title);
  }

  void showCustomToast({
    required String message,
    String? title,
    ToastificationType type = ToastificationType.info,
    Duration autoCloseDuration = const Duration(seconds: 4),
  }) {
    _toastService.showCustom(message: message, title: title, type: type, autoCloseDuration: autoCloseDuration);
  }

  void showLoadingToast(String message, {String? title}) {
    _toastService.showInfo(message, title: title ?? 'Cargando...');
  }

  void showValidationToast(String message) {
    _toastService.showWarning(message, title: 'Datos Incorrectos');
  }

  void showNetworkToast(String message) {
    _toastService.showError(message, title: 'Sin Conexión');
  }

  void showOperationSuccessToast(String message, {String? title}) {
    _toastService.showSuccess(message, title: title ?? 'Operación Exitosa', icon: Icons.check_circle);
  }

  void showProgressToast(String message) {
    _toastService.showInfo(message, title: 'Actualizando...');
  }

  void showDeleteConfirmationToast(String message) {
    _toastService.showWarning(message, title: '¡Atención!');
  }
}
