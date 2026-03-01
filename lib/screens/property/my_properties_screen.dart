import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../widgets/property_card.dart';
import 'property_detail_screen.dart';

/// Pantalla "Mis Propiedades" del propietario (RF-008).
///
/// Muestra todas las propiedades del usuario actual (activas e inactivas).
/// Incluye menú contextual para editar/desactivar/eliminar (RF-007).
class MyPropertiesScreen extends StatelessWidget {
  const MyPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final misPropiedades = MockData.misPropiedades;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Propiedades')),
      body: misPropiedades.isEmpty
          ? _buildVacio(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: misPropiedades.length,
              itemBuilder: (context, index) {
                final propiedad = misPropiedades[index];

                // Stack para poner el menú de tres puntos encima de la tarjeta.
                return Stack(
                  children: [
                    // La tarjeta reutilizable con el flag mostrarEstado.
                    PropertyCard(
                      propiedad: propiedad,
                      mostrarEstado: true, // Muestra "Activa" o "Inactiva"
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PropertyDetailScreen(propiedad: propiedad),
                          ),
                        );
                      },
                    ),

                    // Menú de opciones flotando en la esquina superior derecha.
                    Positioned(
                      top: 8,
                      right: 8,
                      child: PopupMenuButton<String>(
                        // Ícono personalizado (tres puntos con fondo blanco).
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.more_vert,
                            size: 20,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        // Se ejecuta cuando el usuario elige una opción.
                        onSelected: (value) {
                          switch (value) {
                            case 'editar':
                              // TODO: Navegar a pantalla de edición.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edición próximamente'),
                                ),
                              );
                              break;
                            case 'desactivar':
                              // TODO: Cambiar estado en la BD.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    propiedad.activa
                                        ? 'Propiedad desactivada'
                                        : 'Propiedad activada',
                                  ),
                                  backgroundColor: AppTheme.warningColor,
                                ),
                              );
                              break;
                            case 'eliminar':
                              _confirmarEliminacion(context, propiedad);
                              break;
                          }
                        },
                        // Las opciones del menú.
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'editar',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 20),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'desactivar',
                            child: Row(
                              children: [
                                Icon(
                                  propiedad.activa
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  propiedad.activa ? 'Desactivar' : 'Activar',
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'eliminar',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: AppTheme.errorColor,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Eliminar',
                                  style: TextStyle(color: AppTheme.errorColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

      // Botón flotante para crear nueva propiedad.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createProperty),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Vista cuando no hay propiedades registradas.
  Widget _buildVacio(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work_outlined, size: 72, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Aún no tienes propiedades publicadas',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '¡Publica tu primera propiedad!',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.createProperty),
              icon: const Icon(Icons.add),
              label: const Text('Publicar propiedad'),
            ),
          ],
        ),
      ),
    );
  }

  /// Diálogo de confirmación antes de eliminar (RF-007).
  void _confirmarEliminacion(BuildContext context, Propiedad propiedad) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar propiedad?'),
        content: Text(
          'Se eliminará "${propiedad.titulo}" de forma permanente. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Llamar al backend para eliminar.
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Propiedad eliminada'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
