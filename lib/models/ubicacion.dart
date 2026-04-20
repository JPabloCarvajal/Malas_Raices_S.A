class Ubicacion {
  final int idUbicacion;
  final double latitud;
  final double longitud;
  final String direccionCompleta;
  final String ciudad;
  final String barrio;

  const Ubicacion({
    required this.idUbicacion,
    required this.latitud,
    required this.longitud,
    required this.direccionCompleta,
    required this.ciudad,
    required this.barrio,
  });

  String get direccionFormateada => '$direccionCompleta, $barrio, $ciudad';

  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      idUbicacion: json['id_ubicacion'] ?? json['id'] ?? 0,
      latitud: (json['latitud'] ?? 0).toDouble(),
      longitud: (json['longitud'] ?? 0).toDouble(),
      direccionCompleta: (json['direccion_completa'] ?? '').toString(),
      ciudad: (json['ciudad'] ?? '').toString(),
      barrio: (json['barrio'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'latitud': latitud,
        'longitud': longitud,
        'direccion_completa': direccionCompleta,
        'ciudad': ciudad,
        'barrio': barrio,
      };
}