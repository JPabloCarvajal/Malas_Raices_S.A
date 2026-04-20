import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/models.dart';
import '../../services/propiedades_service.dart';
import '../../widgets/property_card.dart';
import 'property_detail_screen.dart';

/// Pantalla "Mis Propiedades" del propietario (RF-008).
/// Muestra todas las propiedades del usuario actual (activas e inactivas).
/// Incluye menú contextual para editar/desactivar/eliminar (RF-007).
class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  final _propiedadesService = PropiedadesService();

  List<Propiedad> _misPropiedades = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  /// Pide al backend la lista de propiedades del usuario actual.
  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    try {
      final propiedades = await _propiedadesService.misPropiedades();
      if (!mounted) return;
      setState(() => _misPropiedades = propiedades);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  /// Llama al backend para cambiar activa/inactiva y recarga.
  Future<void> _cambiarEstado(Propiedad propiedad) async {
    try {
      await _propiedadesService.cambiarEstado(
        propiedad.idPropiedad,
        !propiedad.activa,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            propiedad.activa ? 'Propiedad desactivada' : 'Propiedad activada',
          ),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      await _cargarDatos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  /// Elimina en el backend y recarga.
  Future<void> _eliminar(Propiedad propiedad) async {
    try {
      await _propiedadesService.eliminar(propiedad.idPropiedad);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Propiedad eliminada'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      await _cargarDatos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  /// Diálogo de confirmación antes de eliminar (RF-007).
  void _confirmarEliminacion(Propiedad propiedad) {
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
              Navigator.pop(ctx);
              _eliminar(propiedad);
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

  /// Navega al detalle y, si vuelve, recarga por si hubo cambios.
  Future<void> _irADetalle(Propiedad propiedad) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PropertyDetailScreen(propiedad: propiedad),
      ),
    );
    if (mounted) _cargarDatos();
  }

  /// Navega a crear y, si la crea, recarga para ver la nueva.
  Future<void> _irACrear() async {
    final creada = await Navigator.pushNamed(context, AppRoutes.createProperty);
    if (creada == true && mounted) _cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Propiedades')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarDatos,
              child: _misPropiedades.isEmpty
                  ? ListView(
                      // ListView necesario para que pull-to-refresh funcione sin items.
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: _buildVacio(),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _misPropiedades.length,
                      itemBuilder: (context, index) {
                        final propiedad = _misPropiedades[index];
                        return Stack(
                          children: [
                            PropertyCard(
                              propiedad: propiedad,
                              mostrarEstado: true,
                              onTap: () => _irADetalle(propiedad),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: PopupMenuButton<String>(
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
                                onSelected: (value) {
                                  switch (value) {
                                    case 'editar':
                                      // TODO: implementar pantalla de edición
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Edición próximamente'),
                                        ),
                                      );
                                      break;
                                    case 'desactivar':
                                      _cambiarEstado(propiedad);
                                      break;
                                    case 'eliminar':
                                      _confirmarEliminacion(propiedad);
                                      break;
                                  }
                                },
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
                                          propiedad.activa
                                              ? 'Desactivar'
                                              : 'Activar',
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
                                          style: TextStyle(
                                            color: AppTheme.errorColor,
                                          ),
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
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _irACrear,
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Vista cuando el usuario no tiene propiedades publicadas.
  Widget _buildVacio() {
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
              onPressed: _irACrear,
              icon: const Icon(Icons.add),
              label: const Text('Publicar propiedad'),
            ),
          ],
        ),
      ),
    );
  }
}
