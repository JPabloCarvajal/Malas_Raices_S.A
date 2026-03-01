import '../models/models.dart';

/// Datos ficticios que simulan las respuestas de una base de datos.
/// Se usan para desarrollar y probar las pantallas sin necesidad de backend.
///
/// TODO: Reemplazar por llamadas a la API real cuando esté lista.
class MockData {
  // ─── Usuario que "inició sesión" ───
  // Cambia tipoUsuario a 'arrendatario' para probar la otra vista.
  static final usuarioActual = Usuario(
    idUsuario: 1,
    nombre: 'Carlos Mendoza',
    email: 'carlos@malasraices.com',
    telefono: '3101234567',
    fotoPerfil: '',
    tipoUsuario: 'propietario',
    fechaCreacion: DateTime(2025, 1, 15),
  );

  // ─── Lista de propiedades ───
  static final List<Propiedad> propiedades = [
    Propiedad(
      idPropiedad: 1,
      titulo: 'Apartamento moderno en Cabecera',
      descripcion:
          'Hermoso apartamento con acabados modernos, excelente iluminación '
          'natural y ubicación privilegiada cerca de centros comerciales.',
      precio: 1800000,
      direccion: 'Cra 35 #48-20',
      ciudad: 'Bucaramanga',
      barrio: 'Cabecera del Llano',
      numHabitaciones: 3,
      numBanos: 2,
      areaMt2: 85,
      tipoPropiedad: TipoPropiedad.apartamento,
      activa: true,
      fechaCreacion: DateTime(2025, 6, 1),
      fechaActualizacion: DateTime(2025, 6, 1),
      fotos: [
        FotoPropiedad(
          idFoto: 1,
          urlImagen:
              'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600',
          ordenVisualizacion: 1,
          fechaSubida: DateTime(2025, 6, 1),
        ),
        FotoPropiedad(
          idFoto: 2,
          urlImagen:
              'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600',
          ordenVisualizacion: 2,
          fechaSubida: DateTime(2025, 6, 1),
        ),
      ],
      ubicacion: const Ubicacion(
        idUbicacion: 1,
        latitud: 7.1194,
        longitud: -73.1069,
        direccionCompleta: 'Cra 35 #48-20',
        ciudad: 'Bucaramanga',
        barrio: 'Cabecera del Llano',
      ),
      idPropietario: 1,
    ),

    Propiedad(
      idPropiedad: 2,
      titulo: 'Casa familiar en Cañaveral',
      descripcion:
          'Amplia casa con zona verde privada, ideal para familias. '
          'Garaje doble, cocina integral y excelente ventilación.',
      precio: 2500000,
      direccion: 'Calle 30 #22-15',
      ciudad: 'Floridablanca',
      barrio: 'Cañaveral',
      numHabitaciones: 4,
      numBanos: 3,
      areaMt2: 150,
      tipoPropiedad: TipoPropiedad.casa,
      activa: true,
      fechaCreacion: DateTime(2025, 5, 20),
      fechaActualizacion: DateTime(2025, 5, 20),
      fotos: [
        FotoPropiedad(
          idFoto: 3,
          urlImagen:
              'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=600',
          ordenVisualizacion: 1,
          fechaSubida: DateTime(2025, 5, 20),
        ),
      ],
      ubicacion: const Ubicacion(
        idUbicacion: 2,
        latitud: 7.0636,
        longitud: -73.0897,
        direccionCompleta: 'Calle 30 #22-15',
        ciudad: 'Floridablanca',
        barrio: 'Cañaveral',
      ),
      idPropietario: 1,
    ),

    Propiedad(
      idPropiedad: 3,
      titulo: 'Local comercial en el Centro',
      descripcion:
          'Local en zona de alto tráfico peatonal. '
          'Ideal para tiendas, oficinas o consultorios.',
      precio: 3200000,
      direccion: 'Cra 15 #35-10',
      ciudad: 'Bucaramanga',
      barrio: 'Centro',
      numHabitaciones: 0,
      numBanos: 1,
      areaMt2: 60,
      tipoPropiedad: TipoPropiedad.local,
      activa: true,
      fechaCreacion: DateTime(2025, 4, 10),
      fechaActualizacion: DateTime(2025, 4, 10),
      fotos: [
        FotoPropiedad(
          idFoto: 4,
          urlImagen:
              'https://images.unsplash.com/photo-1497366216548-37526070297c?w=600',
          ordenVisualizacion: 1,
          fechaSubida: DateTime(2025, 4, 10),
        ),
      ],
      ubicacion: const Ubicacion(
        idUbicacion: 3,
        latitud: 7.1254,
        longitud: -73.1198,
        direccionCompleta: 'Cra 15 #35-10',
        ciudad: 'Bucaramanga',
        barrio: 'Centro',
      ),
      idPropietario: 2,
    ),

    Propiedad(
      idPropiedad: 4,
      titulo: 'Apartaestudio en San Alonso',
      descripcion:
          'Cómodo apartaestudio amoblado, perfecto para estudiantes. '
          'Cerca de la UIS.',
      precio: 950000,
      direccion: 'Cra 27 #56-10',
      ciudad: 'Bucaramanga',
      barrio: 'San Alonso',
      numHabitaciones: 1,
      numBanos: 1,
      areaMt2: 35,
      tipoPropiedad: TipoPropiedad.apartamento,
      activa: false, // Esta está INACTIVA para probar "Mis Propiedades"
      fechaCreacion: DateTime(2025, 3, 1),
      fechaActualizacion: DateTime(2025, 7, 15),
      fotos: [
        FotoPropiedad(
          idFoto: 5,
          urlImagen:
              'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=600',
          ordenVisualizacion: 1,
          fechaSubida: DateTime(2025, 3, 1),
        ),
      ],
      ubicacion: const Ubicacion(
        idUbicacion: 4,
        latitud: 7.1146,
        longitud: -73.1226,
        direccionCompleta: 'Cra 27 #56-10',
        ciudad: 'Bucaramanga',
        barrio: 'San Alonso',
      ),
      idPropietario: 1,
    ),

    Propiedad(
      idPropiedad: 5,
      titulo: 'Casa campestre en Ruitoque',
      descripcion:
          'Casa campestre con vista al cañón del Chicamocha. '
          'Piscina, BBQ y amplios espacios verdes.',
      precio: 4500000,
      direccion: 'Km 5 vía Ruitoque',
      ciudad: 'Floridablanca',
      barrio: 'Ruitoque',
      numHabitaciones: 5,
      numBanos: 4,
      areaMt2: 280,
      tipoPropiedad: TipoPropiedad.casa,
      activa: true,
      fechaCreacion: DateTime(2025, 7, 1),
      fechaActualizacion: DateTime(2025, 7, 1),
      fotos: [
        FotoPropiedad(
          idFoto: 6,
          urlImagen:
              'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600',
          ordenVisualizacion: 1,
          fechaSubida: DateTime(2025, 7, 1),
        ),
        FotoPropiedad(
          idFoto: 7,
          urlImagen:
              'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600',
          ordenVisualizacion: 2,
          fechaSubida: DateTime(2025, 7, 1),
        ),
      ],
      ubicacion: const Ubicacion(
        idUbicacion: 5,
        latitud: 7.0450,
        longitud: -73.0750,
        direccionCompleta: 'Km 5 vía Ruitoque',
        ciudad: 'Floridablanca',
        barrio: 'Ruitoque',
      ),
      idPropietario: 2,
    ),
  ];

  // ─── IDs de propiedades favoritas del usuario actual ───
  static final List<int> favoritosIds = [1, 3];

  /// Solo las propiedades activas (para el listado público).
  static List<Propiedad> get propiedadesActivas =>
      propiedades.where((p) => p.activa).toList();

  /// Propiedades del usuario actual (para "Mis Propiedades").
  static List<Propiedad> get misPropiedades => propiedades
      .where((p) => p.idPropietario == usuarioActual.idUsuario)
      .toList();

  /// Propiedades marcadas como favoritas.
  static List<Propiedad> get propiedadesFavoritas =>
      propiedades.where((p) => favoritosIds.contains(p.idPropiedad)).toList();
}
