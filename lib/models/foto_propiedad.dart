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

  factory FotoPropiedad.fromJson(Map<String, dynamic> json) {
    return FotoPropiedad(
      idFoto: json['id_foto'] ?? json['id'] ?? 0,
      urlImagen: (json['url_imagen'] ?? '').toString(),
      ordenVisualizacion: json['orden_visualizacion'] ?? 1,
      fechaSubida:
          DateTime.tryParse(json['fecha_subida']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'url_imagen': urlImagen,
    'orden_visualizacion': ordenVisualizacion,
  };
}
