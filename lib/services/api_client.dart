import 'dart:io';
import 'package:dio/dio.dart';
import '../config/constants.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: kTimeoutSeconds),
        receiveTimeout: const Duration(seconds: kTimeoutSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();
  late final Dio _dio;
  Dio get dio => _dio;

  static String readableError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Tiempo de espera agotado. Verifica tu conexión.';
        case DioExceptionType.connectionError:
          return 'No se pudo conectar al servidor.';
        case DioExceptionType.badResponse:
          final data = error.response?.data;
          if (data is Map) {
            return (data['detail'] ??
                    data['message'] ??
                    data['error'] ??
                    'Error del servidor')
                .toString();
          }
          return 'Error ${error.response?.statusCode ?? 500}';
        default:
          if (error.error is SocketException) return 'Sin conexión a internet.';
          return 'Error de red.';
      }
    }
    return 'Error inesperado';
  }
}
