import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/utils/custom_snackbar.dart';

class AuthController extends GetxController {
  
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  
  // Current user data
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void checkAuthStatus() {
    isLoggedIn.value = StorageService.hasToken;
    
    // Load user data if logged in
    if (isLoggedIn.value) {
      final userData = StorageService.getUserData();
      if (userData != null) {
        currentUser.value = UserModel.fromJson(userData);
      }
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    
    try {
      final user = await ApiService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user != null) {
        isLoggedIn.value = true;
        currentUser.value = user;
        
        CustomSnackbar.showSuccess(
          message: 'Welcome ${user.fullName}!',
        );
        
        Get.offAllNamed('/home');
      } else {
        CustomSnackbar.showError(
          message: 'Login failed',
        );
      }
    } catch (e) {
      CustomSnackbar.showError(
        message: e.toString(),
      );
    }
    
    isLoading.value = false;
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;
    
    try {
      final registerResponse = await ApiService.register(
        emailController.text.trim(),
        passwordController.text,
      );

      if (registerResponse != null) {
        CustomSnackbar.showSuccess(
          message: 'Registration successful! Please login.',
        );
        
        // Clear form and don't auto-login for register
        clearControllers();
      } else {
        CustomSnackbar.showError(
          message: 'Registration failed',
        );
      }
    } catch (e) {
      CustomSnackbar.showError(
        message: e.toString(),
      );
    }
    
    isLoading.value = false;
  }

  Future<void> logout() async {
    await StorageService.clearAll();
    isLoggedIn.value = false;
    currentUser.value = null;
    clearControllers();
    Get.offAllNamed('/login');
    
    CustomSnackbar.showInfo(
      message: 'Logged out successfully',
    );
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void handleTokenExpired() {
    logout();
  }
  
  // Convenience getters
  String get userName => currentUser.value?.fullName ?? 'Guest';
  String get userEmail => currentUser.value?.email ?? '';
  String get userAvatar => currentUser.value?.avatar ?? '';
  bool get hasUser => currentUser.value != null;
}