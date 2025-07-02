import 'package:dio/dio.dart';

import '../constants/sensitive_data.dart';

class ApiServices {
  final Dio _dio = Dio(
    BaseOptions(
        baseUrl: 'https://roukbxhlisygcczaneiw.supabase.co/rest/v1/',
        headers: {
          'apikey': anonKey,
        }),
  );

  /// Get Data
  Future<Response> getData(String path) async {
    return await _dio.get(path);
  }

  /// Post Data
  Future<Response> postData(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  /// Patch Data
  Future<Response> patchData(String path, Map<String, dynamic> data) async {
    return await _dio.patch(path, data: data);
  }

  /// Delete Data
  Future<Response> deleteData(String path) async {
    return await _dio.delete(path);
  }
}
