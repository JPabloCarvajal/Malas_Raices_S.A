/// Modelo que representa una foto asociada a una propiedad.
/// Corresponde a la clase «FotoPropiedad» del diagrama de clases (RF-005).
///
/// Relación de composición: una FotoPropiedad NO existe sin su Propiedad.
/// Cada propiedad puede tener entre 1 y 15 fotos.
class FotoPropiedad {
  final int idFoto;
  final String urlImagen;
  final int ordenVisualizacion;
  final DateTime fechaSubida;

  const FotoPropiedad({
    required this.idFoto,
    required this.urlImagen,
    required this.ordenVisualizacion,
    required this.fechaSubida,
  });

  // TODO: Agregar factory FotoPropiedad.fromJson() cuando se conecte la API.
}
