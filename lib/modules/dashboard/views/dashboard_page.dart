import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/employee_card.dart';
import '../../auth/controllers/auth_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.put(DashboardController());
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Portal'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        authController.logout();
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    'Welcome, ${authController.userName}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    '${dashboardController.totalEmployees.value} employees',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  )),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: dashboardController.searchController,
                      focusNode: dashboardController.searchFocusNode,
                      onChanged: dashboardController.updateSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search employees...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: Obx(() => dashboardController.searchQuery.value.isNotEmpty
                          ? IconButton(
                              onPressed: dashboardController.clearSearch,
                              icon: const Icon(Icons.clear),
                            )
                          : const SizedBox.shrink(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (dashboardController.isLoading.value && dashboardController.employees.isEmpty) {
                return const LoadingWidget();
              }

              if (dashboardController.employees.isEmpty && !dashboardController.isLoading.value) {
                return const Center(
                  child: Text(
                    'No employees found',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              final employees = dashboardController.filteredEmployees;

              if (employees.isEmpty && dashboardController.searchQuery.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No employees found for "${dashboardController.searchQuery.value}"',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: dashboardController.refreshEmployees,
                child: ListView.builder(
                  itemCount: employees.length + (dashboardController.hasMoreData.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == employees.length) {
                      // Load more indicator
                      if (dashboardController.isLoadingMore.value) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (dashboardController.hasMoreData.value) {
                        // Trigger load more when reaching end
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (dashboardController.searchQuery.value.isEmpty) {
                            dashboardController.loadMoreEmployees();
                          }
                        });
                        return const SizedBox.shrink();
                      }
                      return const SizedBox.shrink();
                    }

                    final employee = employees[index];
                    return EmployeeCard(
                      employee: employee,
                      onTap: () {
                        dashboardController.unfocusSearch();
                        Get.toNamed(AppRoutes.employeeDetail, arguments: employee);
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addEmployee);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}