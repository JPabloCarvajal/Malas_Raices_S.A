/// Funciones de validación reutilizables para formularios.
/// Se usan en login, registro, crear propiedad, perfil, etc.
class Validators {
  /// Valida formato de correo electrónico.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null; // null significa "sin errores"
  }

  /// Valida contraseña (mínimo 6 caracteres).
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  /// Valida que un campo no esté vacío.
  static String? requerido(String? value, [String campo = 'Este campo']) {
    if (value == null || value.trim().isEmpty) {
      return '$campo es obligatorio';
    }
    return null;
  }

  /// Valida que el valor sea un número.
  static String? numero(String? value, [String campo = 'Este campo']) {
    if (value == null || value.isEmpty) {
      return '$campo es obligatorio';
    }
    if (double.tryParse(value) == null) {
      return 'Ingresa un número válido';
    }
    return null;
  }

  /// Valida teléfono colombiano (10 dígitos).
  static String? telefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es obligatorio';
    }
    if (value.length < 10) {
      return 'Ingresa un teléfono válido (10 dígitos)';
    }
    return null;
  }
}
