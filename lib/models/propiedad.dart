import 'tipo_propiedad.dart';
import 'foto_propiedad.dart';
import 'ubicacion.dart';

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
  final List<FotoPropiedad> fotos;
  final Ubicacion ubicacion;
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

  String get precioFormateado {
    final parts = precio.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) buffer.write('.');
      buffer.write(parts[i]);
    }
    return '\$${buffer.toString()}';
  }

  String get imagenPrincipal => fotos.isNotEmpty ? fotos.first.urlImagen : '';

  /// El backend envía las fotos como List<String> plana.
  /// Las convertimos a FotoPropiedad para seguir usando el mismo widget.
  factory Propiedad.fromJson(Map<String, dynamic> json) {
    final fotosRaw = (json['fotos'] as List?) ?? [];
    final fotosList = <FotoPropiedad>[];
    for (int i = 0; i < fotosRaw.length; i++) {
      fotosList.add(
        FotoPropiedad(
          idFoto: i + 1,
          urlImagen: fotosRaw[i].toString(),
          ordenVisualizacion: i + 1,
          fechaSubida: DateTime.now(),
        ),
      );
    }

    final lat = (json['latitud'] ?? 0).toDouble();
    final lng = (json['longitud'] ?? 0).toDouble();
    final direccion = (json['direccion'] ?? '').toString();
    final ciudad = (json['ciudad'] ?? '').toString();
    final barrio = (json['barrio'] ?? '').toString();

    return Propiedad(
      idPropiedad: json['id'] ?? 0,
      titulo: (json['titulo'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      precio: (json['precio'] ?? 0).toDouble(),
      direccion: direccion,
      ciudad: ciudad,
      barrio: barrio,
      numHabitaciones: json['num_habitaciones'] ?? 0,
      numBanos: json['num_banos'] ?? 0,
      areaMt2: (json['area_mt2'] ?? 0).toDouble(),
      tipoPropiedad: _parseTipo(json['tipo_propiedad']),
      activa: json['activa'] ?? true,
      fechaCreacion:
          DateTime.tryParse(json['fecha_creacion']?.toString() ?? '') ??
          DateTime.now(),
      fechaActualizacion:
          DateTime.tryParse(json['fecha_actualizacion']?.toString() ?? '') ??
          DateTime.now(),
      fotos: fotosList,
      ubicacion: Ubicacion(
        idUbicacion: json['id'] ?? 0,
        latitud: lat,
        longitud: lng,
        direccionCompleta: direccion,
        ciudad: ciudad,
        barrio: barrio,
      ),
      idPropietario: json['id_propietario'] ?? 0,
    );
  }

  static TipoPropiedad _parseTipo(dynamic value) {
    final str = value?.toString().toLowerCase() ?? '';
    if (str == 'casa') return TipoPropiedad.casa;
    if (str == 'local') return TipoPropiedad.local;
    return TipoPropiedad.apartamento;
  }
}
