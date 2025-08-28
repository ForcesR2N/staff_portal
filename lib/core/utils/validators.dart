import 'package:get/get.dart';

class Validators {
  static String? email(String? value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    if (!GetUtils.isEmail(value!)) return 'Please enter a valid email';
    return null;
  }
  
  static String? password(String? value) {
    if (value?.isEmpty ?? true) return 'Password is required';
    if (value!.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
  
  static String? name(String? value) {
    if (value?.isEmpty ?? true) return 'Name is required';
    if (value!.length < 2) return 'Name must be at least 2 characters';
    return null;
  }
  
  static String? confirmPassword(String? value, String password) {
    if (value?.isEmpty ?? true) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }
  
  static String? required(String? value, String fieldName) {
    if (value?.isEmpty ?? true) return '$fieldName is required';
    return null;
  }
}