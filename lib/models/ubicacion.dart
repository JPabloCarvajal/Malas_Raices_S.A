/// Modelo que representa la ubicación geográfica de una propiedad.
/// Corresponde a la clase «Ubicacion» del diagrama de clases (RF-006).
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

  /// Devuelve la dirección en formato legible para la UI.
  String get direccionFormateada => '$direccionCompleta, $barrio, $ciudad';

  // TODO: Agregar factory Ubicacion.fromJson() cuando se conecte la API.
}
