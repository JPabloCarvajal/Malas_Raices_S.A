/// Enumeracion que clasifica los tipos de inmueble disponibles.
/// Corresponde al enum «TipoPropiedad» del diagrama de clases (RF-010).
enum TipoPropiedad { casa, apartamento, local }

/// Extension utilitaria para obtener el nombre legible del tipo.
/// En vez de mostrar "TipoPropiedad.casa" en la pantalla,
/// mostramos "Casa" usando propiedad.tipoPropiedad.label
extension TipoPropiedadExtension on TipoPropiedad {
  String get label {
    switch (this) {
      case TipoPropiedad.casa:
        return 'Casa';
      case TipoPropiedad.apartamento:
        return 'Apartamento';
      case TipoPropiedad.local:
        return 'Local';
    }
  }
}

// Una Extension es una forma de agregarle metodods a una clase sin modificarla
// Asi en cualquier parte de la app se puede hacer TipoPropiedad.casa.label y devuelve "Casa"
