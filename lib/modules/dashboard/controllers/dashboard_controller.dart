import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/custom_snackbar.dart';

class DashboardController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxList<UserModel> employees = <UserModel>[].obs;
  final RxList<UserModel> filteredEmployees = <UserModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalEmployees = 0.obs;
  final RxBool hasMoreData = true.obs;

  // TextEditingController for search field
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  static const int employeesPerPage = 10;

  @override
  void onInit() {
    super.onInit();
    loadEmployees();

    // Listen to search query changes
    debounce(searchQuery, (_) => _filterEmployees(),
        time: const Duration(milliseconds: 500));
  }

  Future<void> loadEmployees({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      employees.clear();
      filteredEmployees.clear();
    }

    if (!hasMoreData.value) return;

    isLoading.value = !isRefresh && employees.isEmpty;
    isLoadingMore.value = !isLoading.value;

    try {
      final skip = (currentPage.value - 1) * employeesPerPage;
      final response = await ApiService.getUsers(
        limit: employeesPerPage,
        skip: skip,
      );

      if (response != null) {
        final List<dynamic> usersData = response['users'] ?? [];
        final List<UserModel> newEmployees =
            usersData.map((userData) => UserModel.fromJson(userData)).toList();

        if (isRefresh) {
          employees.assignAll(newEmployees);
        } else {
          employees.addAll(newEmployees);
        }

        totalEmployees.value = response['total'] ?? 0;
        hasMoreData.value = newEmployees.length >= employeesPerPage;
        currentPage.value++;

        _filterEmployees();
      }
    } catch (e) {
      CustomSnackbar.showError(
        message: 'Failed to load employees: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshEmployees() async {
    await loadEmployees(isRefresh: true);
  }

  Future<void> loadMoreEmployees() async {
    if (!isLoadingMore.value && hasMoreData.value) {
      await loadEmployees();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void _filterEmployees() {
    if (searchQuery.value.isEmpty) {
      filteredEmployees.assignAll(employees);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredEmployees.assignAll(
        employees.where((employee) =>
            employee.firstName.toLowerCase().contains(query) ||
            employee.lastName.toLowerCase().contains(query) ||
            employee.fullName.toLowerCase().contains(query) ||
            employee.email.toLowerCase().contains(query)),
      );
    }
  }

  void clearSearch() {
    searchController.clear(); // Clear UI field
    searchQuery.value = ''; // Clear reactive variable
    searchFocusNode.unfocus(); // Remove focus from search field
  }

  void unfocusSearch() {
    searchFocusNode.unfocus();
  }

  UserModel? getEmployeeById(int id) {
    try {
      return employees.firstWhere((employee) => employee.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
