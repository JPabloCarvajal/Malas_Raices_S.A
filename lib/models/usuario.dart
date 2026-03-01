/// Modelo base que representa un usuario de la plataforma.
/// Corresponde a la clase Usuario del diagrama de clases.
///
/// En el diagrama UML, Propietario y Arrendatario heredan de Usuario.
/// Aquí usamos el campo "tipoUsuario" para diferenciar roles,
class Usuario {
  final int idUsuario;
  final String nombre;
  final String email;
  final String telefono;
  final String fotoPerfil;
  final String tipoUsuario; // 'propietario' o 'arrendatario'
  final DateTime fechaCreacion;

  const Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.fotoPerfil,
    required this.tipoUsuario,
    required this.fechaCreacion,
  });

  /// Verifica si el usuario tiene rol de propietario.
  bool get esPropietario => tipoUsuario == 'propietario';

  /// Verifica si el usuario tiene rol de arrendatario.
  bool get esArrendatario => tipoUsuario == 'arrendatario';

  // TODO: Agregar factory Usuario.fromJson() cuando se conecte la API.
}
