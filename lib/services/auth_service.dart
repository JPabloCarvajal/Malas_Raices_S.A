import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/usuario.dart';
import 'api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;

  /// Login: guardamos el usuario completo (incluyendo su ID)
  /// porque el backend lo usa para identificar al usuario en otros endpoints.
  Future<Usuario> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final usuario = Usuario.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kUsuarioKey, jsonEncode(usuario.toJson()));
      // Mantenemos kTokenKey como marca de "sesión iniciada" aunque no usemos JWT real.
      await prefs.setString(kTokenKey, 'local_${usuario.idUsuario}');

      return usuario;
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  Future<Usuario> registro({
    required String nombre,
    required String email,
    required String telefono,
    required String password,
    required String tipoUsuario,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/registro',
        data: {
          'nombre': nombre,
          'email': email,
          'telefono': telefono,
          'password': password,
          'tipo_usuario': tipoUsuario,
        },
      );
      return Usuario.fromJson(Map<String, dynamic>.from(response.data));
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kTokenKey);
    await prefs.remove(kUsuarioKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(kTokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Usuario guardado localmente — el backend no tiene "me", así que usamos este.
  Future<Usuario?> getUsuarioLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(kUsuarioKey);
    if (raw == null) return null;
    return Usuario.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Refresca el perfil contra el backend.
  Future<Usuario> getPerfil() async {
    final local = await getUsuarioLocal();
    if (local == null) throw Exception('No hay sesión iniciada');

    try {
      final response = await _dio.get('/perfil/${local.idUsuario}');
      final usuario = Usuario.fromJson(
        Map<String, dynamic>.from(response.data),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kUsuarioKey, jsonEncode(usuario.toJson()));
      return usuario;
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }

  /// Actualiza el perfil en el backend.
  Future<Usuario> actualizarPerfil({String? nombre, String? telefono}) async {
    final local = await getUsuarioLocal();
    if (local == null) throw Exception('No hay sesión iniciada');

    try {
      final body = <String, dynamic>{};
      if (nombre != null) body['nombre'] = nombre;
      if (telefono != null) body['telefono'] = telefono;

      final response = await _dio.put('/perfil/${local.idUsuario}', data: body);
      final usuario = Usuario.fromJson(
        Map<String, dynamic>.from(response.data),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kUsuarioKey, jsonEncode(usuario.toJson()));
      return usuario;
    } on DioException catch (e) {
      throw Exception(ApiClient.readableError(e));
    }
  }
}
