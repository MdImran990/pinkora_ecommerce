import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/storage_keys.dart';

/// One shared Dio client for all API calls.
///
/// Not used yet: the repositories still return local mock data. When the
/// backend is ready, call `Get.find<DioProvider>().dio` from a repository:
///
///   final response = await _api.dio.get(ApiConstants.products);
class DioProvider {
  DioProvider() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Sends the login token with every request.
          final token = _box.read<String>(StorageKeys.authToken);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  late final Dio dio;

  final GetStorage _box = GetStorage();

  /// A short message that is safe to show to the user.
  static String messageOf(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          break;
      }

      final data = error.response?.data;

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      return 'Something went wrong (${error.response?.statusCode ?? '-'}).';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }
}
