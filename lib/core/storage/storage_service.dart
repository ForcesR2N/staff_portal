import 'package:get_storage/get_storage.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  static final GetStorage _box = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static String? getToken() {
    return _box.read(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  static Future<void> removeToken() async {
    await _box.remove(_tokenKey);
  }

  static Map<String, dynamic>? getUserData() {
    return _box.read(_userKey);
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _box.write(_userKey, userData);
  }

  static Future<void> removeUserData() async {
    await _box.remove(_userKey);
  }

  static Future<void> clearAll() async {
    await _box.erase();
  }

  static bool get hasToken => getToken() != null;
}