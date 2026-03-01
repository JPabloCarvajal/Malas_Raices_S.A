import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../widgets/property_card.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../property/property_detail_screen.dart';

/// Pantalla principal de la app.
/// Muestra el listado de propiedades con búsqueda y filtros.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  // Lista que se muestra en pantalla (cambia con la búsqueda).
  List<Propiedad> _propiedadesMostradas = [];

  // IDs de favoritos del usuario actual.
  List<int> _favoritosIds = [];

  @override
  void initState() {
    super.initState();
    // Cargamos datos iniciales del mock.
    _propiedadesMostradas = MockData.propiedadesActivas;
    _favoritosIds = List.from(MockData.favoritosIds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtra propiedades según el texto de búsqueda (RF-009).
  void _buscar(String query) {
    setState(() {
      if (query.isEmpty) {
        _propiedadesMostradas = MockData.propiedadesActivas;
      } else {
        final queryLower = query.toLowerCase();
        _propiedadesMostradas = MockData.propiedadesActivas.where((p) {
          return p.titulo.toLowerCase().contains(queryLower) ||
              p.descripcion.toLowerCase().contains(queryLower) ||
              p.barrio.toLowerCase().contains(queryLower) ||
              p.ciudad.toLowerCase().contains(queryLower);
        }).toList();
      }
    });
  }

  /// Agrega o quita una propiedad de favoritos (RF-012).
  void _toggleFavorito(int idPropiedad) {
    setState(() {
      if (_favoritosIds.contains(idPropiedad)) {
        _favoritosIds.remove(idPropiedad);
      } else {
        _favoritosIds.add(idPropiedad);
      }
    });
    // TODO: Llamar al backend para persistir el cambio.
  }

  /// Abre el bottom sheet de filtros (RF-010).
  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  /// Navega al detalle de una propiedad.
  void _irADetalle(Propiedad propiedad) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailScreen(propiedad: propiedad),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MalasRaíces'),
        actions: [
          // Botón de filtros en el AppBar.
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Filtros',
            onPressed: _abrirFiltros,
          ),
        ],
      ),

      // Menú lateral.
      drawer: _buildDrawer(),

      body: Column(
        children: [
          // Barra de búsqueda (RF-009).
          _buildBarraBusqueda(),

          // Lista de propiedades.
          Expanded(
            child: _propiedadesMostradas.isEmpty
                ? _buildSinResultados()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _propiedadesMostradas.length,
                    itemBuilder: (context, index) {
                      final propiedad = _propiedadesMostradas[index];
                      return PropertyCard(
                        propiedad: propiedad,
                        onTap: () => _irADetalle(propiedad),
                        esFavorito: _favoritosIds.contains(
                          propiedad.idPropiedad,
                        ),
                        onFavoritoTap: () =>
                            _toggleFavorito(propiedad.idPropiedad),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Botón flotante solo si es Propietario.
      floatingActionButton: MockData.usuarioActual.esPropietario
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.createProperty);
              },
              icon: const Icon(Icons.add),
              label: const Text('Publicar'),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  /// Barra de búsqueda sobre fondo azul.
  Widget _buildBarraBusqueda() {
    return Container(
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _searchController,
        onChanged: _buscar,
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, barrio, ciudad...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _buscar('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  /// Vista cuando no hay resultados.
  Widget _buildSinResultados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No se encontraron propiedades',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'Intenta con otras palabras clave',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  /// Menú lateral (Drawer).
  Widget _buildDrawer() {
    final usuario = MockData.usuarioActual;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Cabecera con info del usuario.
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  usuario.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  usuario.email,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Opciones de navegación.
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context),
          ),

          // Solo para Propietarios.
          if (usuario.esPropietario)
            ListTile(
              leading: const Icon(Icons.apartment_outlined),
              title: const Text('Mis Propiedades'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.myProperties);
              },
            ),

          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Favoritos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.favorites);
            },
          ),

          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Mi perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.errorColor),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: AppTheme.errorColor),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
