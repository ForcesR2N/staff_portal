import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';
import '../storage/storage_service.dart';
import '../utils/custom_snackbar.dart';
import '../../routes/app_routes.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static void _initDio() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) {
            print('API_LOG: $obj');
          },
        ),
      );
    }

    // Add auth token to requests
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _handleTokenExpired();
          }
          handler.next(error);
        },
      ),
    );
  }

  static void _handleTokenExpired() {
    StorageService.clearAll();
    Get.offAllNamed(AppRoutes.login);
    CustomSnackbar.showWarning(
      message: 'Session expired. Please login again.',
    );
  }

  static Future<UserModel?> login(String email, String password) async {
    _initDio();
    
    try {
      // Convert email to username for DummyJSON cuz DummyJSON 
      // doesnt accept login uses email only username and password
      String username = email;
      if (email.contains('@')) {
        username = email.split('@')[0];
      }

      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(response.data);
        
        // Convert to UserModel for app usage
        final user = UserModel.fromLoginResponse(loginResponse);
        
        // Save token and user data
        await StorageService.saveToken(loginResponse.accessToken);
        await StorageService.saveUserData(user.toJson());
        
        return user;
      }
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  static Future<Map<String, dynamic>?> register(String email, String password) async {
    _initDio();
    
    try {
      String username = email;
      if (email.contains('@')) {
        username = email.split('@')[0];
      }

      final response = await _dio.post(
        '/users/add',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  // called 10 users only each called
  static Future<Map<String, dynamic>?> getUsers({
    int limit = 10,
    int skip = 0,
    String? search,
  }) async {
    _initDio();
    
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit,
        'skip': skip,
      };
      
      String endpoint = '/users';
      if (search != null && search.isNotEmpty) {
        endpoint = '/users/search';
        queryParams['q'] = search;
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  static Future<UserModel?> getUserById(int id) async {
    _initDio();
    
    try {
      final response = await _dio.get('/users/$id');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  static Future<bool> addEmployee(Map<String, dynamic> employeeData) async {
    _initDio();
    
    try {
      final response = await _dio.post(
        '/users/add',
        data: employeeData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  // Update user - PUT /users/{id}
  static Future<bool> updateUser(int id, Map<String, dynamic> userData) async {
    _initDio();
    
    try {
      final response = await _dio.put(
        '/users/$id',
        data: userData,
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  // Delete user - DELETE /users/{id}  
  static Future<bool> deleteUser(int id) async {
    _initDio();
    
    try {
      final response = await _dio.delete('/users/$id');

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  static String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        String message = 'Request failed';
        
        if (responseData is Map<String, dynamic>) {
          message = responseData['error'] ?? responseData['message'] ?? message;
        } else if (responseData is String) {
          message = responseData;
        }
        
        return 'Error: $message${statusCode != null ? ' (HTTP $statusCode)' : ''}';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.unknown:
      default:
        return 'Network error: ${error.message ?? 'Unknown error occurred'}';
    }
  }
}