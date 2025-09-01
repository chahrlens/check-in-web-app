import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  static void success({required String title, required String message}) {
    _showToast(
      title: title,
      subTitle: message,
      type: ToastificationType.success,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void error({required String title, required String message}) {
    _showToast(
      title: title,
      subTitle: message,
      type: ToastificationType.error,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void warning({required String title, required String message}) {
    _showToast(
      title: title,
      subTitle: message,
      type: ToastificationType.warning,
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }

  static void _showToast({
    required String title,
    required String subTitle,
    required ToastificationType type,
    required Icon icon,
  }) {
    toastification.show(
      type: type,
      icon: icon,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      description: Text(subTitle),
      autoCloseDuration: const Duration(seconds: 5),
      showProgressBar: true,
      style: ToastificationStyle.fillColored,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(16),
    );
  }
}
