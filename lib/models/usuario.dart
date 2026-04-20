class Usuario {
  final int idUsuario;
  final String nombre;
  final String email;
  final String telefono;
  final String fotoPerfil;
  final String tipoUsuario;
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

  bool get esPropietario => tipoUsuario == 'propietario';
  bool get esArrendatario => tipoUsuario == 'arrendatario';

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['id'] ?? 0,
      nombre: (json['nombre'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      telefono: (json['telefono'] ?? '').toString(),
      fotoPerfil: (json['foto_perfil'] ?? '').toString(),
      tipoUsuario: (json['tipo_usuario'] ?? 'arrendatario').toString(),
      fechaCreacion:
          DateTime.tryParse(json['fecha_creacion']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': idUsuario,
    'nombre': nombre,
    'email': email,
    'telefono': telefono,
    'foto_perfil': fotoPerfil,
    'tipo_usuario': tipoUsuario,
    'fecha_creacion': fechaCreacion.toIso8601String(),
  };
}
