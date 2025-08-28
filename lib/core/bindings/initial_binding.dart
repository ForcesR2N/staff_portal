import 'package:get/get.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../storage/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize storage service first
    _initializeStorage();
    
    // Initialize global controllers
    Get.put<AuthController>(AuthController(), permanent: true);
  }
  
  Future<void> _initializeStorage() async {
    await StorageService.init();
  }
}