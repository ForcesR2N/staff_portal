import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Get.theme.primaryColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                MediaQuery.of(context).padding.top - 
                MediaQuery.of(context).padding.bottom - 
                kToolbarHeight - 24 * 2,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: controller.registerFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    _buildHeader(),
                    const SizedBox(height: 32.0),
                    _buildEmailField(),
                    const SizedBox(height: 16.0),
                    _buildPasswordField(),
                    const SizedBox(height: 16.0),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 24.0),
                    _buildRegisterButton(),
                    const SizedBox(height: 16.0),
                    _buildLoginLink(),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.person_add_outlined,
          size: 80,
          color: Get.theme.primaryColor,
        ),
        const SizedBox(height: 16.0),
        Text(
          'Join Staff Portal',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Get.theme.primaryColor,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Create your account to get started',
          style: Get.textTheme.bodyLarge?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: controller.emailController,
      labelText: 'Email',
      hintText: 'Enter your email',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
      validator: Validators.email,
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => CustomTextField(
        controller: controller.passwordController,
        labelText: 'Password',
        hintText: 'Enter your password',
        obscureText: controller.obscurePassword.value,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            controller.obscurePassword.value
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
        validator: Validators.password,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
      () => CustomTextField(
        controller: controller.confirmPasswordController,
        labelText: 'Confirm Password',
        hintText: 'Confirm your password',
        obscureText: controller.obscureConfirmPassword.value,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            controller.obscureConfirmPassword.value
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: controller.toggleConfirmPasswordVisibility,
        ),
        validator: (value) => Validators.confirmPassword(
          value,
          controller.passwordController.text,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Obx(
      () => CustomButton(
        text: 'Create Account',
        onPressed: controller.register,
        isLoading: controller.isLoading.value,
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: Get.textTheme.bodyMedium,
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: Text(
            'Sign In',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
