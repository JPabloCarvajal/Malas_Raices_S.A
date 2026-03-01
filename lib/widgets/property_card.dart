import 'package:flutter/material.dart';
import '../models/models.dart';
import '../config/theme.dart';

/// Tarjeta visual que muestra la vista previa de una propiedad.
///
/// Se reutiliza en: HomeScreen, FavoritesScreen, MyPropertiesScreen.
/// Recibe un objeto [Propiedad] y callbacks para las interacciones.
class PropertyCard extends StatelessWidget {
  final Propiedad propiedad;
  final VoidCallback onTap; // Al tocar la tarjeta completa
  final bool esFavorito; // ¿Está marcada como favorita?
  final VoidCallback? onFavoritoTap; // Al tocar el corazón
  final bool mostrarEstado; // Muestra "Activa/Inactiva" (Mis Propiedades)

  const PropertyCard({
    super.key,
    required this.propiedad,
    required this.onTap,
    this.esFavorito = false,
    this.onFavoritoTap,
    this.mostrarEstado = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      // clipBehavior recorta la imagen para que no se salga
      // de los bordes redondeados de la tarjeta.
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Imagen con overlays ───
            _buildImagen(),

            // ─── Información textual ───
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Precio destacado.
                  Text(
                    '${propiedad.precioFormateado}/mes',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Título de la propiedad.
                  Text(
                    propiedad.titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // "..." si es muy largo.
                  ),
                  const SizedBox(height: 4),

                  // Ubicación con ícono.
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${propiedad.barrio}, ${propiedad.ciudad}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Características: habitaciones, baños, área.
                  _buildCaracteristicas(),

                  // Chip de estado (solo en "Mis Propiedades").
                  if (mostrarEstado) ...[
                    const SizedBox(height: 8),
                    _buildChipEstado(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Imagen de la propiedad con el chip de tipo y el botón de favorito encima.
  Widget _buildImagen() {
    return Stack(
      children: [
        // La imagen en sí.
        SizedBox(
          height: 180,
          width: double.infinity,
          child: propiedad.imagenPrincipal.isNotEmpty
              ? Image.network(
                  propiedad.imagenPrincipal,
                  fit: BoxFit.cover,
                  // Mientras carga, muestra un fondo gris con spinner.
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  // Si falla la carga, muestra un ícono genérico.
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.home_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                )
              : Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.home_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
        ),

        // Chip "Casa" / "Apartamento" / "Local" (esquina superior izquierda).
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              propiedad.tipoPropiedad.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Botón de favorito (esquina superior derecha).
        // Solo aparece si se pasó el callback onFavoritoTap.
        if (onFavoritoTap != null)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoritoTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  esFavorito ? Icons.favorite : Icons.favorite_border,
                  color: esFavorito ? Colors.red : Colors.grey,
                  size: 22,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Fila de íconos: habitaciones, baños, área.
  Widget _buildCaracteristicas() {
    return Row(
      children: [
        // Solo muestra habitaciones si tiene (un Local puede tener 0).
        if (propiedad.numHabitaciones > 0) ...[
          _iconoCaracteristica(
            Icons.bed_outlined,
            '${propiedad.numHabitaciones} hab.',
          ),
          const SizedBox(width: 16),
        ],
        _iconoCaracteristica(
          Icons.bathtub_outlined,
          '${propiedad.numBanos} baño${propiedad.numBanos > 1 ? 's' : ''}',
        ),
        const SizedBox(width: 16),
        _iconoCaracteristica(
          Icons.square_foot,
          '${propiedad.areaMt2.toStringAsFixed(0)} m²',
        ),
      ],
    );
  }

  /// Un ícono + texto pequeño (helper reutilizable dentro de este widget).
  Widget _iconoCaracteristica(IconData icono, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Text(
          texto,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  /// Chip verde "Activa" o gris "Inactiva".
  Widget _buildChipEstado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: propiedad.activa
            // ignore: deprecated_member_use
            ? AppTheme.successColor.withOpacity(0.1)
            // ignore: deprecated_member_use
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: propiedad.activa ? AppTheme.successColor : Colors.grey,
          width: 0.5,
        ),
      ),
      child: Text(
        propiedad.activa ? 'Activa' : 'Inactiva',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: propiedad.activa ? AppTheme.successColor : Colors.grey,
        ),
      ),
    );
  }
}
