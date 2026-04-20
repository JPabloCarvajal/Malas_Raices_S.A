import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class BiometricService {
  final _auth = LocalAuthentication();
  final _secureStorage = const FlutterSecureStorage();

  static const _emailKey = 'bio_email';
  static const _passwordKey = 'bio_password';

  /// ¿El dispositivo soporta biometría?
  Future<bool> disponible() async {
    try {
      final soportado = await _auth.isDeviceSupported();
      final puedeUsar = await _auth.canCheckBiometrics;
      return soportado && puedeUsar;
    } catch (_) {
      return false;
    }
  }

  /// ¿El usuario ya activó el login con huella?
  Future<bool> estaActivado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kBiometricEnabledKey) ?? false;
  }

  /// Activa el login con huella guardando credenciales de forma segura.
  Future<void> activar({
    required String email,
    required String password,
  }) async {
    await _secureStorage.write(key: _emailKey, value: email);
    await _secureStorage.write(key: _passwordKey, value: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kBiometricEnabledKey, true);
  }

  Future<void> desactivar() async {
    await _secureStorage.delete(key: _emailKey);
    await _secureStorage.delete(key: _passwordKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kBiometricEnabledKey, false);
  }

  /// Pide la huella y, si pasa, devuelve las credenciales guardadas.
  Future<Map<String, String>?> autenticarYObtenerCredenciales() async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: 'Confirma tu identidad para iniciar sesión',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (!ok) return null;

      final email = await _secureStorage.read(key: _emailKey);
      final password = await _secureStorage.read(key: _passwordKey);
      if (email == null || password == null) return null;

      return {'email': email, 'password': password};
    } catch (_) {
      return null;
    }
  }
}
