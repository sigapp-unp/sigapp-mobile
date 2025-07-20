import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/auth/domain/services/toast_service.dart';
import 'package:toastification/toastification.dart';

@Singleton(as: ToastService)
class ToastServiceImpl implements ToastService {
  ToastServiceImpl();

  @override
  void show(String message, {String? title, bool isError = false}) {
    toastification.show(
      title: title != null ? Text(title) : null,
      type: isError ? ToastificationType.error : ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 8),
      description: Text(message),
    );
  }
}
