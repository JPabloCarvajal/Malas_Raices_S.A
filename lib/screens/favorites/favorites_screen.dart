import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/favoritos_service.dart';
import '../../widgets/property_card.dart';
import '../property/property_detail_screen.dart';

/// Pantalla de propiedades guardadas como favoritas (RF-012).
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favoritosService = FavoritosService();

  List<Propiedad> _favoritos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  /// Pide la lista de favoritos al backend.
  Future<void> _cargarFavoritos() async {
    setState(() => _cargando = true);
    try {
      final favoritos = await _favoritosService.listar();
      if (!mounted) return;
      setState(() => _favoritos = favoritos);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  /// Quita un favorito con opción de deshacer.
  /// Hace UI optimista: elimina de la lista ANTES de confirmar con el backend.
  Future<void> _quitarFavorito(Propiedad propiedad) async {
    // Guardamos la posición para poder restaurar si el usuario presiona "Deshacer".
    final indiceOriginal = _favoritos.indexWhere(
      (p) => p.idPropiedad == propiedad.idPropiedad,
    );

    setState(() {
      _favoritos.removeWhere((p) => p.idPropiedad == propiedad.idPropiedad);
    });

    try {
      await _favoritosService.quitar(propiedad.idPropiedad);
    } catch (e) {
      // Si falla, devolvemos la propiedad a su lugar.
      if (!mounted) return;
      setState(() => _favoritos.insert(indiceOriginal, propiedad));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${propiedad.titulo} eliminado de favoritos'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () async {
            try {
              await _favoritosService.agregar(propiedad.idPropiedad);
              if (!mounted) return;
              setState(() => _favoritos.insert(indiceOriginal, propiedad));
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString().replaceFirst('Exception: ', '')),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarFavoritos,
              child: _favoritos.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: _buildVacio(),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _favoritos.length,
                      itemBuilder: (context, index) {
                        final propiedad = _favoritos[index];
                        return PropertyCard(
                          propiedad: propiedad,
                          esFavorito: true,
                          onFavoritoTap: () => _quitarFavorito(propiedad),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PropertyDetailScreen(propiedad: propiedad),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
    );
  }

  Widget _buildVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 72, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No tienes favoritos aún',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Explora propiedades y guarda las que te gusten',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
