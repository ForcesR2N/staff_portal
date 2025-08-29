import 'package:get/get.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/auth/views/register_page.dart';
import '../modules/dashboard/views/dashboard_page.dart';
import '../modules/employee/views/employee_detail_page.dart';
import '../modules/employee/views/add_employee_page.dart';
import '../modules/employee/views/edit_employee_page.dart';

class AppRoutes {
  AppRoutes._();
  
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String employeeDetail = '/employee-detail';
  static const String addEmployee = '/add-employee';
  static const String editEmployee = '/edit-employee';

  static final routes = [
    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardPage(),
    ),
    GetPage(
      name: employeeDetail,
      page: () => const EmployeeDetailPage(),
    ),
    GetPage(
      name: addEmployee,
      page: () => const AddEmployeePage(),
    ),
    GetPage(
      name: editEmployee,
      page: () => const EditEmployeePage(),
    ),
  ];
}