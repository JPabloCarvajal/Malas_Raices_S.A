import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/models.dart';
import '../../services/propiedades_service.dart';
import '../../services/favoritos_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/property_card.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../property/property_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _propiedadesService = PropiedadesService();
  final _favoritosService = FavoritosService();
  final _authService = AuthService();

  List<Propiedad> _todas = [];
  List<Propiedad> _propiedadesMostradas = [];
  List<int> _favoritosIds = [];
  Usuario? _usuarioActual;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    try {
      final results = await Future.wait([
        _propiedadesService.listarActivas(),
        _favoritosService.listarIds(),
        _authService.getUsuarioLocal(),
      ]);
      if (!mounted) return;
      setState(() {
        _todas = results[0] as List<Propiedad>;
        _propiedadesMostradas = _todas;
        _favoritosIds = results[1] as List<int>;
        _usuarioActual = results[2] as Usuario?;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _buscar(String query) {
    setState(() {
      if (query.isEmpty) {
        _propiedadesMostradas = _todas;
      } else {
        final q = query.toLowerCase();
        _propiedadesMostradas = _todas.where((p) {
          return p.titulo.toLowerCase().contains(q) ||
              p.descripcion.toLowerCase().contains(q) ||
              p.barrio.toLowerCase().contains(q) ||
              p.ciudad.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  Future<void> _toggleFavorito(int idPropiedad) async {
    final esFav = _favoritosIds.contains(idPropiedad);
    try {
      if (esFav) {
        await _favoritosService.quitar(idPropiedad);
      } else {
        await _favoritosService.agregar(idPropiedad);
      }
      setState(() {
        if (esFav) {
          _favoritosIds.remove(idPropiedad);
        } else {
          _favoritosIds.add(idPropiedad);
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

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
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Filtros',
            onPressed: _abrirFiltros,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          _buildBarraBusqueda(),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _cargarDatos,
                    child: _propiedadesMostradas.isEmpty
                        ? ListView(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: _buildSinResultados(),
                              ),
                            ],
                          )
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
          ),
        ],
      ),
      floatingActionButton: (_usuarioActual?.esPropietario ?? false)
          ? FloatingActionButton.extended(
              onPressed: () async {
                final creada = await Navigator.pushNamed(
                  context,
                  AppRoutes.createProperty,
                );
                if (creada == true) _cargarDatos();
              },
              icon: const Icon(Icons.add),
              label: const Text('Publicar'),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

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

  Widget _buildDrawer() {
    final usuario = _usuarioActual;

    if (usuario == null) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
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
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context),
          ),
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
            onTap: () async {
              await _authService.logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
