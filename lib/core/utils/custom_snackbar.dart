import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  // Debouncer untuk prevent spam
  static DateTime? _lastShownTime;
  static const Duration _debounceDelay = Duration(milliseconds: 500);
  
  // Private method untuk cek debounce
  static bool _canShow() {
    final now = DateTime.now();
    if (_lastShownTime == null || 
        now.difference(_lastShownTime!) > _debounceDelay) {
      _lastShownTime = now;
      return true;
    }
    return false;
  }

  static void showSuccess({
    required String message,
    String? title,
    Duration? duration,
  }) {
    if (!_canShow()) return;
    
    Get.snackbar(
      title ?? 'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 2),
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
      borderRadius: 0,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      isDismissible: true,
    );
  }

  static void showError({
    required String message,
    String? title,
    Duration? duration,
  }) {
    if (!_canShow()) return;
    
    Get.snackbar(
      title ?? 'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 4), 
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
      borderRadius: 0,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      isDismissible: true,
    );
  }

  static void showWarning({
    required String message,
    String? title,
    Duration? duration,
  }) {
    if (!_canShow()) return;
    
    Get.snackbar(
      title ?? 'Warning',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
      borderRadius: 0,
      icon: const Icon(
        Icons.warning,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      isDismissible: true,
    );
  }

  static void showInfo({
    required String message,
    String? title,
    Duration? duration,
  }) {
    if (!_canShow()) return;
    
    Get.snackbar(
      title ?? 'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 2),
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
      borderRadius: 0,
      icon: const Icon(
        Icons.info,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      isDismissible: true,
    );
  }

  static void showLoading({
    required String message,
    String? title,
    Duration? duration,
  }) {
    if (!_canShow()) return;
    
    Get.snackbar(
      title ?? 'Loading',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[700],
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 1),
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
      borderRadius: 0,
      icon: const Icon(
        Icons.hourglass_top,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      isDismissible: true,
    );
  }

  static void showCustom({
    required String message,
    String? title,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration? duration,
  }) {
    if (!_canShow()) return;
    
    Get.snackbar(
      title ?? 'Notification',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor ?? Colors.grey[800],
      colorText: textColor ?? Colors.white,
      duration: duration ?? const Duration(seconds: 2),
      margin: const EdgeInsets.only(bottom: 0, left: 0, right: 0),
      borderRadius: 0,
      icon: icon != null ? Icon(
        icon,
        color: textColor ?? Colors.white,
        size: 24,
      ) : null,
      shouldIconPulse: false,
      isDismissible: true,
    );
  }

  // untuk clear debounce
  static void clearDebounce() {
    _lastShownTime = null;
  }
}