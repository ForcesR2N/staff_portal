import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_portal/modules/dashboard/controllers/dashboard_controller.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/custom_snackbar.dart';

class AddEmployeeController extends GetxController {
  final RxBool isLoading = false.obs;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    positionController.dispose();
    salaryController.dispose();
    super.onClose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email format';
    }
    return null;
  }

  String? validatePosition(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Job position is required';
    }
    if (value.trim().length < 2) {
      return 'Position must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Position cannot exceed 100 characters';
    }
    return null;
  }

  String? validateSalary(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Salary is required';
    }
    
    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericValue.isEmpty) {
      return 'Salary must be a valid number';
    }
    
    final salary = int.tryParse(numericValue);
    if (salary == null) {
      return 'Invalid salary format';
    }
    
    if (salary < 1000000) {
      return 'Minimum salary is Rp 1,000,000';
    }
    
    if (salary > 1000000000) {
      return 'Maximum salary is Rp 1,000,000,000';
    }
    
    return null;
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final employeeData = {
        'firstName': nameController.text.trim().split(' ')[0],
        'lastName': nameController.text.trim().contains(' ') 
            ? nameController.text.trim().split(' ').skip(1).join(' ')
            : '',
        'email': emailController.text.trim(),
        'position': positionController.text.trim(),
        'salary': int.parse(salaryController.text.replaceAll(RegExp(r'[^0-9]'), '')),
      };

      final success = await ApiService.addEmployee(employeeData);

      if (success) {
        _showSuccessDialog();
      } else {
        CustomSnackbar.showError(
          message: 'Failed to add employee. Please try again.',
        );
      }
    } catch (e) {
      CustomSnackbar.showError(
        message: 'Error: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        title: const Text('Success!'),
        content: Text(
          'Employee "${nameController.text.trim()}" has been added successfully.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to dashboard
              
              // Refresh dashboard data
              try {
                final dashboardController = Get.find<DashboardController>();
                dashboardController.refreshEmployees();
              } catch (e) {
                // Dashboard controller might not be loaded yet
              }
              
              CustomSnackbar.showSuccess(
                message: 'Employee added successfully!',
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    positionController.clear();
    salaryController.clear();
    formKey.currentState?.reset();
  }
}