import 'package:dio/dio.dart';
import '../models/propiedad.dart';
import 'api_client.dart';
import 'auth_service.dart';

class PropiedadesService {
  final Dio _dio = ApiClient.instance.dio;
  final AuthService _authService = AuthService();

  Future<List<Propiedad>> listarActivas() async {
    try {
      final response = await _dio.get('/propiedades/');
      return (response.data as List)
          .map((e) => Propiedad.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  Future<List<Propiedad>> misPropiedades() async {
    final usuario = await _authService.getUsuarioLocal();
    if (usuario == null) throw Exception('No hay sesión iniciada');

    try {
      final response = await _dio.get(
        '/propiedades/usuario/${usuario.idUsuario}',
      );
      return (response.data as List)
          .map((e) => Propiedad.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  Future<Propiedad> obtener(int id) async {
    try {
      final response = await _dio.get('/propiedades/$id');
      return Propiedad.fromJson(Map<String, dynamic>.from(response.data));
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  /// El backend recibe id_propietario como QUERY PARAM, no en body.
  Future<Propiedad> crear(Map<String, dynamic> data) async {
    final usuario = await _authService.getUsuarioLocal();
    if (usuario == null) throw Exception('No hay sesión iniciada');

    try {
      final response = await _dio.post(
        '/propiedades/',
        data: data,
        queryParameters: {'id_propietario': usuario.idUsuario},
      );
      return Propiedad.fromJson(Map<String, dynamic>.from(response.data));
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  Future<void> eliminar(int id) async {
    try {
      await _dio.delete('/propiedades/$id');
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  /// Cambio de estado: el backend usa PUT con body {activa: true/false}.
  Future<void> cambiarEstado(int id, bool activa) async {
    try {
      await _dio.put('/propiedades/$id', data: {'activa': activa});
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }
}
