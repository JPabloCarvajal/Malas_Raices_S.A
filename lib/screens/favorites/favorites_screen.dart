import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../widgets/property_card.dart';
import '../property/property_detail_screen.dart';

/// Pantalla de propiedades guardadas como favoritas (RF-012).
///
/// TODO: Conectar con backend para persistir los favoritos.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Copia local de los favoritos del mock.
  // Usamos List.from() para crear una copia independiente,
  // así podemos modificarla sin afectar el mock original.
  late List<Propiedad> _favoritos;

  @override
  void initState() {
    super.initState();
    _favoritos = List.from(MockData.propiedadesFavoritas);
  }

  /// Quita una propiedad de favoritos con opción de deshacer.
  void _quitarFavorito(Propiedad propiedad) {
    setState(() {
      _favoritos.removeWhere((p) => p.idPropiedad == propiedad.idPropiedad);
    });

    // TODO: Llamar al backend para eliminar el favorito.

    // SnackBar con botón "Deshacer" para recuperar el favorito.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${propiedad.titulo} eliminado de favoritos'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            // Vuelve a agregar la propiedad a la lista.
            setState(() => _favoritos.add(propiedad));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: _favoritos.isEmpty
          // Vista vacía cuando no hay favoritos.
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 72,
                    color: Colors.grey[400],
                  ),
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
            )
          // Lista de favoritos.
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoritos.length,
              itemBuilder: (context, index) {
                final propiedad = _favoritos[index];
                return PropertyCard(
                  propiedad: propiedad,
                  esFavorito:
                      true, // Siempre true aquí porque estamos en favoritos.
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
    );
  }
}
