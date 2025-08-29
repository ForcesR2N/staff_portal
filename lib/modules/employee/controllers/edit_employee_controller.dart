import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class EditEmployeeController extends GetxController {
  final UserModel employee;
  final RxBool isLoading = false.obs;
  
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  
  final RxString selectedGender = 'male'.obs;
  final Rx<DateTime?> selectedBirthDate = Rx<DateTime?>(null);
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditEmployeeController({required this.employee});

  @override
  void onInit() {
    super.onInit();
    _populateFields();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    titleController.dispose();
    departmentController.dispose();
    super.onClose();
  }

  void _populateFields() {
    firstNameController.text = employee.firstName;
    lastNameController.text = employee.lastName;
    emailController.text = employee.email;
    phoneController.text = employee.phone ?? '';
    titleController.text = employee.title ?? '';
    departmentController.text = employee.department ?? '';
    
    // Handle gender
    selectedGender.value = employee.gender.toLowerCase();
    
    // Handle birth date - use existing birthDate or fallback
    selectedBirthDate.value = employee.birthDate;
    
    // If birthDate is null use age if exists
    if (selectedBirthDate.value == null && employee.age != null) {
      final estimatedBirthYear = DateTime.now().year - employee.age!;
      selectedBirthDate.value = DateTime(estimatedBirthYear, 1, 1);
    }
  }

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    return Validators.email(value);
  }

  String? validatePhone(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length < 10) {
        return 'Phone number must be at least 10 digits';
      }
    }
    return null; // Phone is optional
  }

  String? validateTitle(String? value) {
    // Title is optional
    return null;
  }

  String? validateDepartment(String? value) {
    // Department is optional  
    return null;
  }

  void selectBirthDate() async {
    final DateTime? picked = await Get.dialog<DateTime>(
      DatePickerDialog(
        initialDate: selectedBirthDate.value ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
      ),
    );
    
    if (picked != null) {
      selectedBirthDate.value = picked;
    }
  }

  Future<void> updateEmployee() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final updateData = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'gender': selectedGender.value,
      };

      // Add optional fields if provided
      if (phoneController.text.trim().isNotEmpty) {
        updateData['phone'] = phoneController.text.trim();
      }
      
      if (titleController.text.trim().isNotEmpty) {
        updateData['title'] = titleController.text.trim();
      }
      
      if (departmentController.text.trim().isNotEmpty) {
        updateData['department'] = departmentController.text.trim();
      }
      
      if (selectedBirthDate.value != null) {
        final bd = selectedBirthDate.value!;
        updateData['birthDate'] = '${bd.year}-${bd.month}-${bd.day}';
      }

      final success = await ApiService.updateUser(employee.id, updateData);

      if (success) {
        _showSuccessDialog();
      } else {
        CustomSnackbar.showError(
          message: 'Failed to update employee. Please try again.',
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
        title: const Text('Updated Successfully!'),
        content: Text(
          'Employee "${firstNameController.text.trim()} ${lastNameController.text.trim()}" has been updated.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to detail page
              
              // Refresh dashboard data
              try {
                final dashboardController = Get.find<DashboardController>();
                dashboardController.refreshEmployees();
              } catch (e) {
                // Dashboard controller might not be loaded
              }
              
              CustomSnackbar.showSuccess(
                message: 'Employee updated successfully!',
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}