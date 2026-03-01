import 'tipo_propiedad.dart';
import 'foto_propiedad.dart';
import 'ubicacion.dart';

/// Modelo principal que representa un inmueble publicado en la plataforma.
/// Corresponde a la clase «Propiedad» del diagrama de clases.
///
/// Cubre: RF-004 (Publicar), RF-007 (Edición/Eliminación),
///        RF-008 (Mis Propiedades), RF-011 (Vista de Detalle).
class Propiedad {
  final int idPropiedad;
  final String titulo;
  final String descripcion;
  final double precio;
  final String direccion;
  final String ciudad;
  final String barrio;
  final int numHabitaciones;
  final int numBanos;
  final double areaMt2;
  final TipoPropiedad tipoPropiedad;
  final bool activa;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  // Composición: fotos y ubicación pertenecen a esta propiedad.
  final List<FotoPropiedad> fotos;
  final Ubicacion ubicacion;

  // Referencia al propietario que publicó esta propiedad.
  final int idPropietario;

  const Propiedad({
    required this.idPropiedad,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.direccion,
    required this.ciudad,
    required this.barrio,
    required this.numHabitaciones,
    required this.numBanos,
    required this.areaMt2,
    required this.tipoPropiedad,
    required this.activa,
    required this.fechaCreacion,
    required this.fechaActualizacion,
    required this.fotos,
    required this.ubicacion,
    required this.idPropietario,
  });

  /// Precio formateado con separador de miles para mostrar en la UI.
  String get precioFormateado {
    final parts = precio.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(parts[i]);
    }
    return '\$${buffer.toString()}';
  }

  /// Primera foto de la galería para usar como thumbnail.
  String get imagenPrincipal => fotos.isNotEmpty ? fotos.first.urlImagen : '';

  // TODO: Agregar factory Propiedad.fromJson() cuando se conecte la API.
}
