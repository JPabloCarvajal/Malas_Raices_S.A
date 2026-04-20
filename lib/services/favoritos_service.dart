import 'package:dio/dio.dart';
import '../models/propiedad.dart';
import 'api_client.dart';
import 'auth_service.dart';

class FavoritosService {
  final Dio _dio = ApiClient.instance.dio;
  final AuthService _authService = AuthService();

  Future<List<Propiedad>> listar() async {
    final usuario = await _authService.getUsuarioLocal();
    if (usuario == null) throw Exception('No hay sesión iniciada');

    try {
      final response = await _dio.get('/favoritos/${usuario.idUsuario}');
      return (response.data as List)
          .map((e) => Propiedad.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  Future<List<int>> listarIds() async {
    final favoritos = await listar();
    return favoritos.map((p) => p.idPropiedad).toList();
  }

  Future<void> agregar(int idPropiedad) async {
    final usuario = await _authService.getUsuarioLocal();
    if (usuario == null) throw Exception('No hay sesión iniciada');

    try {
      await _dio.post(
        '/favoritos/${usuario.idUsuario}',
        data: {'id_propiedad': idPropiedad},
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  Future<void> quitar(int idPropiedad) async {
    final usuario = await _authService.getUsuarioLocal();
    if (usuario == null) throw Exception('No hay sesión iniciada');

    try {
      await _dio.delete('/favoritos/${usuario.idUsuario}/$idPropiedad');
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }
}
