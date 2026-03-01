/// Modelo que representa la relación de favorito entre usuario y propiedad.
/// Corresponde a la clase «Favorito» del diagrama de clases (RF-012).
class Favorito {
  final int idFavorito;
  final int idUsuario;
  final int idPropiedad;
  final DateTime fechaAgregado;

  const Favorito({
    required this.idFavorito,
    required this.idUsuario,
    required this.idPropiedad,
    required this.fechaAgregado,
  });

  // TODO: Agregar factory Favorito.fromJson() cuando se conecte la API.
}
