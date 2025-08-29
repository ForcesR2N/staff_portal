import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_portal/routes/app_routes.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class EmployeeDetailPage extends StatelessWidget {
  const EmployeeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel employee = Get.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(employee.fullName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Avatar
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: employee.image != null
                          ? NetworkImage(employee.image!)
                          : null,
                      backgroundColor: Colors.white,
                      child: employee.image == null
                          ? Text(
                              _getInitials(employee.fullName),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      employee.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.email,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Combined Personal & Professional Info
                  _buildInfoCard(
                    context,
                    'Employee Information',
                    [
                      _buildInfoRow(
                          Icons.person, 'Username', employee.username),
                      _buildInfoRow(Icons.work, 'Job Title', employee.jobTitle),
                      _buildInfoRow(
                          Icons.business, 'Department', employee.jobDepartment),
                      _buildInfoRow(Icons.wc, 'Gender',
                          _capitalizeFirst(employee.gender)),
                      if (employee.birthDate != null)
                        _buildInfoRow(
                            Icons.cake, 'Date of Birth', _formatBirthDate(employee.birthDate!)),
                      _buildInfoRow(
                          Icons.tag, 'Employee ID', '#${employee.id}'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Contact Information
                  if (employee.phone != null || employee.address != null)
                    _buildInfoCard(
                      context,
                      'Contact Information',
                      [
                        if (employee.phone != null)
                          _buildInfoRow(Icons.phone, 'Phone', employee.phone!),
                        if (employee.address != null)
                          _buildInfoRow(
                              Icons.location_on, 'Address', employee.address!),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // CRUD Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.toNamed(AppRoutes.editEmployee,
                                arguments: employee);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showDeleteDialog(context, employee),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';

    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }

    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _formatBirthDate(DateTime birthDate) {
    return '${birthDate.year}-${birthDate.month}-${birthDate.day}';
  }

  void _showDeleteDialog(BuildContext context, UserModel employee) {
    Get.dialog(
      AlertDialog(
        icon: const Icon(
          Icons.warning,
          color: Colors.red,
          size: 64,
        ),
        title: const Text('Delete Employee'),
        content: Text(
          'Are you sure you want to delete "${employee.fullName}"?\n\nThis action cannot be undone.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _deleteEmployee(employee),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _deleteEmployee(UserModel employee) async {
    // Show loading
    Get.back(); // Close dialog
    Get.dialog(
      const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Deleting employee...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final success = await ApiService.deleteUser(employee.id);

      Get.back(); // Close loading dialog

      if (success) {
        // Show success dialog
        Get.dialog(
          AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            title: const Text('Deleted Successfully!'),
            content: Text(
              'Employee "${employee.fullName}" has been deleted.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close success dialog
                  Get.back(); // Go back to dashboard

                  // Refresh dashboard data
                  try {
                    final dashboardController = Get.find<DashboardController>();
                    dashboardController.refreshEmployees();
                  } catch (e) {
                    // Dashboard controller might not be loaded yte
                  }

                  CustomSnackbar.showSuccess(
                    message: 'Employee deleted successfully!',
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        CustomSnackbar.showError(
          message: 'Failed to delete employee. Please try again.',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomSnackbar.showError(
        message: 'Error: ${e.toString()}',
      );
    }
  }
}
