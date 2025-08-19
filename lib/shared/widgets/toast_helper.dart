import 'package:nexus/presentation/di/service_locator.dart';
import 'package:nexus/shared/constants/message.contants.dart';
import 'package:nexus/core/utils/toast/toast_service.dart';
import 'package:flutter/material.dart';

class ToastHelper {
  static final _service = getIt<ToastService>();

  static void success([String? message, IconData? icon, VoidCallback? onTap]) {
    _service.showSuccess(
      message ?? MessageConstants.operationSuccessful,
      title: MessageConstants.successTitle,
      icon: icon,
      onTap: onTap,
    );
  }

  static void error([String? message]) {
    _service.showError(message ?? MessageConstants.genericError, title: MessageConstants.errorTitle);
  }

  static void warning([String? message]) {
    _service.showWarning(message ?? MessageConstants.confirmAction, title: MessageConstants.warningTitle);
  }

  static void info([String? message]) {
    _service.showInfo(message ?? MessageConstants.updateAvailable, title: MessageConstants.infoTitle);
  }

  static void custom({required String message, String? title, Duration duration = const Duration(seconds: 4)}) {
    _service.showCustom(message: message, title: title, autoCloseDuration: duration);
  }

  static void showLoading(String message) {
    _service.showInfo(message, title: 'Cargando...');
  }

  static void showCompleted(String message) {
    _service.showSuccess(message, title: 'Completado', icon: Icons.check_circle);
  }

  static void showUpdateNotice(String message) {
    _service.showInfo(message, title: 'Actualización');
  }

  static void networkError() => error(MessageConstants.networkError);

  static void serverError() => error(MessageConstants.serverError);

  static void unauthorized() => error(MessageConstants.unauthorizedError);

  static void notFound() => error(MessageConstants.notFoundError);

  static void validationError() => warning(MessageConstants.validationError);

  static void noConnection() => error(MessageConstants.noInternetConnection);

  static void connectionRestored({IconData? icon, VoidCallback? onTap}) {
    Future.delayed(const Duration(milliseconds: 500), () {
      success(MessageConstants.connectionRestored, icon, onTap);
    });
  }

  static void noData() => info(MessageConstants.noDataAvailable);

  static void loading() => info(MessageConstants.loading);

  static void dataUpdated() => success(MessageConstants.dataUpdated);

  static void dataSaved() => success(MessageConstants.dataSaved);

  static void dataDeleted() => success(MessageConstants.dataDeleted);

  static void unsavedChanges() => warning(MessageConstants.unsavedChanges);

  static void confirmDelete() => warning(MessageConstants.dataWillBeDeleted);

  static void updateAvailable() => info(MessageConstants.updateAvailable);
}
