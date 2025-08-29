import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/user_model.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/edit_employee_controller.dart';

class EditEmployeePage extends StatelessWidget {
  const EditEmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel employee = Get.arguments as UserModel;
    final EditEmployeeController controller = Get.put(
      EditEmployeeController(employee: employee),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 48,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Edit Employee',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Update employee information',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // First Name Field
                CustomTextField(
                  controller: controller.firstNameController,
                  labelText: 'First Name',
                  hintText: 'Enter first name',
                  prefixIcon: const Icon(Icons.person),
                  validator: controller.validateFirstName,
                ),

                const SizedBox(height: 24),

                // Last Name Field
                CustomTextField(
                  controller: controller.lastNameController,
                  labelText: 'Last Name',
                  hintText: 'Enter last name',
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: controller.validateLastName,
                ),

                const SizedBox(height: 24),

                // Email Field
                CustomTextField(
                  controller: controller.emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter email address',
                  prefixIcon: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),

                const SizedBox(height: 24),

                // Phone Field
                CustomTextField(
                  controller: controller.phoneController,
                  labelText: 'Phone Number',
                  hintText: 'Enter phone number',
                  prefixIcon: const Icon(Icons.phone),
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                ),

                const SizedBox(height: 24),

                // Gender Field
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedGender.value,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          prefixIcon: Icon(Icons.wc),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male')),
                          DropdownMenuItem(
                              value: 'female', child: Text('Female')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedGender.value = value;
                          }
                        },
                      ),
                    )),

                const SizedBox(height: 24),

                // Birth Date Field
                Text(
                  'Date of Birth',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => InkWell(
                      onTap: controller.selectBirthDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.cake, color: Colors.grey),
                            const SizedBox(width: 12),
                            Text(
                              controller.selectedBirthDate.value != null
                                  ? '${controller.selectedBirthDate.value!.day}/${controller.selectedBirthDate.value!.month}/${controller.selectedBirthDate.value!.year}'
                                  : 'Select birth date',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    controller.selectedBirthDate.value != null
                                        ? Colors.black87
                                        : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                const SizedBox(height: 32),

                // Professional Information Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Professional Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Job Title Field
                      CustomTextField(
                        controller: controller.titleController,
                        labelText: 'Job Title',
                        hintText: 'Enter job title',
                        prefixIcon: const Icon(Icons.work),
                        validator: controller.validateTitle,
                      ),

                      const SizedBox(height: 16),

                      // Department Field
                      CustomTextField(
                        controller: controller.departmentController,
                        labelText: 'Department',
                        hintText: 'Enter department',
                        prefixIcon: const Icon(Icons.business),
                        validator: controller.validateDepartment,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => CustomButton(
                        text: 'Update Employee',
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.updateEmployee,
                        isLoading: controller.isLoading.value,
                        backgroundColor: Colors.blue,
                      )),
                ),

                const SizedBox(height: 16),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed:
                        controller.isLoading.value ? null : () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
