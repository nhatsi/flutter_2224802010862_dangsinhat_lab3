import 'package:dio/dio.dart';

class AuthService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://69ddf46d410caa3d47ba5312.mockapi.io',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final res = await _dio.get('/login'); // 👈 sửa ở đây
      final users = res.data as List;

      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );

      if (user != null) {
        return {
          'success': true,
          'message': 'Đăng nhập thành công',
          'user': user,
        };
      }

      return {
        'success': false,
        'message': 'Sai email hoặc mật khẩu',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'K kết nối đc API',
      };
    }
  }

  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final res = await _dio.get('/login'); 
      final users = res.data as List;

      final exists = users.any((u) => u['email'] == email);
      if (exists) {
        return {
          'success': false,
          'message': 'Email đã tồn tại',
        };
      }

      final newUser = await _dio.post(
        '/login', 
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      return {
        'success': true,
        'message': 'Đăng ký thành công',
        'user': newUser.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Đăng ký thất bại',
      };
    }
  }
}