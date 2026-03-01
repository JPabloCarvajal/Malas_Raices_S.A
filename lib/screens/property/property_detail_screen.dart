import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Pantalla de detalle completo de una propiedad (RF-011).
///
/// También cubre:
///   RF-013 — Botón "Llamar" (por ahora muestra un mensaje).
///   RF-014 — Botón "Compartir" (por ahora muestra un mensaje).
///
/// TODO: Integrar Google Maps para el mapa real.
/// TODO: Implementar url_launcher para llamadas.
/// TODO: Implementar share_plus para compartir.
class PropertyDetailScreen extends StatefulWidget {
  final Propiedad propiedad;

  const PropertyDetailScreen({super.key, required this.propiedad});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  // Índice de la foto visible actualmente en el carrusel.
  int _fotoActual = 0;

  @override
  Widget build(BuildContext context) {
    final propiedad = widget.propiedad;

    return Scaffold(
      // Hace que el body se extienda detrás del AppBar,
      // para que la galería de fotos llegue hasta arriba.
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Botón de volver con fondo oscuro para que se vea sobre la imagen.
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: Colors.black45,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),

      // Contenido scrolleable.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galería de fotos.
            _buildGaleriaFotos(propiedad),

            // Información de la propiedad.
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Precio y tipo.
                  _buildPrecioYTipo(propiedad),
                  const SizedBox(height: 8),

                  // Título.
                  Text(
                    propiedad.titulo,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Ubicación con ícono.
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          propiedad.ubicacion.direccionFormateada,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tarjetas de características.
                  _buildCaracteristicas(propiedad),
                  const SizedBox(height: 20),

                  // Descripción.
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    propiedad.descripcion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.5, // Interlineado para mejor lectura.
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Placeholder del mapa.
                  _buildPlaceholderMapa(propiedad),

                  // Espacio extra para que los botones fijos no tapen contenido.
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      // Botones fijos abajo: Llamar y Compartir.
      bottomNavigationBar: _buildBotonesAccion(),
    );
  }

  /// Carrusel de fotos con indicador de puntos y contador.
  Widget _buildGaleriaFotos(Propiedad propiedad) {
    return Stack(
      children: [
        // El carrusel en sí.
        SizedBox(
          height: 280,
          child: PageView.builder(
            itemCount: propiedad.fotos.length,
            onPageChanged: (index) {
              setState(() => _fotoActual = index);
            },
            itemBuilder: (context, index) {
              return Image.network(
                propiedad.fotos[index].urlImagen,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 48),
                  );
                },
              );
            },
          ),
        ),

        // Puntos indicadores (solo si hay más de 1 foto).
        if (propiedad.fotos.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(propiedad.fotos.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  // El punto activo es más ancho (una barrita).
                  width: _fotoActual == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _fotoActual == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

        // Contador "1/3" en la esquina inferior derecha.
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_fotoActual + 1}/${propiedad.fotos.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  /// Fila con el precio grande a la izquierda y el chip de tipo a la derecha.
  Widget _buildPrecioYTipo(Propiedad propiedad) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${propiedad.precioFormateado}/mes',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            propiedad.tipoPropiedad.label,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  /// Tres tarjetitas: habitaciones, baños, área.
  Widget _buildCaracteristicas(Propiedad propiedad) {
    return Row(
      children: [
        if (propiedad.numHabitaciones > 0)
          Expanded(
            child: _chipCaracteristica(
              Icons.bed_outlined,
              '${propiedad.numHabitaciones}',
              'Habitaciones',
            ),
          ),
        if (propiedad.numHabitaciones > 0) const SizedBox(width: 8),
        Expanded(
          child: _chipCaracteristica(
            Icons.bathtub_outlined,
            '${propiedad.numBanos}',
            'Baños',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _chipCaracteristica(
            Icons.square_foot,
            propiedad.areaMt2.toStringAsFixed(0),
            'm²',
          ),
        ),
      ],
    );
  }

  /// Una tarjetita individual de característica.
  Widget _chipCaracteristica(IconData icono, String valor, String etiqueta) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icono, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            etiqueta,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  /// Caja gris que representa donde irá el mapa de Google Maps.
  Widget _buildPlaceholderMapa(Propiedad propiedad) {
    // Definimos la posición inicial basada en la propiedad
    final CameraPosition posicionInicial = CameraPosition(
      target: LatLng(propiedad.ubicacion.latitud, propiedad.ubicacion.longitud),
      zoom: 15,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ubicación',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          // Para mantener los bordes redondeados que ya tenías
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: GoogleMap(
              initialCameraPosition: posicionInicial,
              markers: {
                Marker(
                  markerId: const MarkerId('propiedad_loc'),
                  position: LatLng(
                    propiedad.ubicacion.latitud,
                    propiedad.ubicacion.longitud,
                  ),
                  infoWindow: InfoWindow(title: propiedad.titulo),
                ),
              },
              // Configuraciones recomendadas para una vista de detalle:
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              scrollGesturesEnabled:
                  false, // Evita que el mapa se mueva al hacer scroll en la pantalla
            ),
          ),
        ),
      ],
    );
  }

  /// Barra inferior fija con botones de Llamar y Compartir.
  Widget _buildBotonesAccion() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botón "Llamar" (RF-013).
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementar con url_launcher:
                // launchUrl(Uri.parse('tel:+573101234567'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función de llamada próximamente'),
                  ),
                );
              },
              icon: const Icon(Icons.phone),
              label: const Text('Llamar'),
            ),
          ),
          const SizedBox(width: 12),
          // Botón "Compartir" (RF-014).
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Implementar con share_plus:
                // Share.share('Mira esta propiedad: ${propiedad.titulo}');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función de compartir próximamente'),
                  ),
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Compartir'),
            ),
          ),
        ],
      ),
    );
  }
}
