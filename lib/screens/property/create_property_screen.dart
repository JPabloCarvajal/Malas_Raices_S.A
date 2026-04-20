import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/tipo_propiedad.dart';
import '../../widgets/custom_text_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import '../../services/propiedades_service.dart';

/// Pantalla para crear una nueva publicación de propiedad (RF-004).
///
/// Incluye placeholders para:
///   RF-005 — Carga de fotos (botón simulado).
///   RF-006 — Geolocalización (placeholder de mapa).
///
/// TODO: Conectar con backend para guardar la propiedad.
/// TODO: Implementar image_picker para subir fotos reales.
/// TODO: Integrar Google Maps para seleccionar ubicación.
class CreatePropertyScreen extends StatefulWidget {
  const CreatePropertyScreen({super.key});

  @override
  State<CreatePropertyScreen> createState() => _CreatePropertyScreenState();
}

class _CreatePropertyScreenState extends State<CreatePropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  LatLng? _ubicacionSeleccionada;
  // Coordenadas iniciales (Bucaramanga como punto de partida)
  static const LatLng _puntoInicial = LatLng(7.1193, -73.1227);

  // Un controlador por cada campo de texto.
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _barrioController = TextEditingController();
  final _habitacionesController = TextEditingController();
  final _banosController = TextEditingController();
  final _areaController = TextEditingController();

  // Tipo de propiedad seleccionado en el dropdown.
  TipoPropiedad _tipoSeleccionado = TipoPropiedad.apartamento;
  // Simula cuántas fotos ha seleccionado el usuario.
  int _fotosSeleccionadas = 0;
  bool _cargando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _barrioController.dispose();
    _habitacionesController.dispose();
    _banosController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _onPublicar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_fotosSeleccionadas < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes agregar al menos 1 foto'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }
    if (_ubicacionSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona la ubicación en el mapa'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    setState(() => _cargando = true);
    try {
      await PropiedadesService().crear({
        'titulo': _tituloController.text.trim(),
        'descripcion': _descripcionController.text.trim(),
        'precio': double.parse(_precioController.text),
        'direccion': _direccionController.text.trim(),
        'ciudad': _ciudadController.text.trim(),
        'barrio': _barrioController.text.trim(),
        'num_habitaciones': int.parse(_habitacionesController.text),
        'num_banos': int.parse(_banosController.text),
        'area_mt2': double.parse(_areaController.text),
        'tipo_propiedad': _tipoSeleccionado.name,
        'latitud': _ubicacionSeleccionada!.latitude,
        'longitud': _ubicacionSeleccionada!.longitude,
        // TODO: implementar upload real con POST /imagenes/subir-multiple.
        // Por ahora mandamos un placeholder para que el backend acepte.
        'fotos': [
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=600',
        ],
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Propiedad publicada'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva publicación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Sección: Fotos ───
              _buildSeccionFotos(),
              const SizedBox(height: 24),

              // ─── Sección: Información básica ───
              const Text(
                'Información de la propiedad',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Título de la publicación',
                hint: 'Ej: Apartamento moderno en Cabecera',
                controller: _tituloController,
                prefixIcon: Icons.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              CustomTextField(
                label: 'Descripción',
                hint: 'Describe las características del inmueble...',
                controller: _descripcionController,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Dropdown de tipo de propiedad.
              _buildSelectorTipo(),
              const SizedBox(height: 14),

              CustomTextField(
                label: 'Precio mensual (\$)',
                hint: '1500000',
                controller: _precioController,
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El precio es obligatorio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ─── Sección: Características ───
              const Text(
                'Características',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Tres campos en fila: habitaciones, baños, área.
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Habitaciones',
                      hint: '3',
                      controller: _habitacionesController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Baños',
                      hint: '2',
                      controller: _banosController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Área m²',
                      hint: '85',
                      controller: _areaController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ─── Sección: Ubicación ───
              const Text(
                'Ubicación',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Dirección',
                hint: 'Cra 35 #48-20',
                controller: _direccionController,
                prefixIcon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La dirección es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Ciudad',
                      hint: 'Bucaramanga',
                      controller: _ciudadController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Barrio',
                      hint: 'Cabecera',
                      controller: _barrioController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Placeholder del mapa.
              _buildPlaceholderMapa(),
              const SizedBox(height: 32),

              // ─── Botón de publicar ───
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _cargando ? null : _onPublicar,
                  icon: _cargando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.publish),
                  label: Text(
                    _cargando ? 'Publicando...' : 'Publicar propiedad',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Sección de fotos con botón para agregar (RF-005).
  Widget _buildSeccionFotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fotos de la propiedad',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Mínimo 1, máximo 15 fotos',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            // TODO: Abrir image_picker para seleccionar fotos reales.
            // Por ahora simulamos que se agrega una foto.
            setState(() {
              if (_fotosSeleccionadas < 15) _fotosSeleccionadas++;
            });
          },
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  _fotosSeleccionadas > 0
                      ? '$_fotosSeleccionadas foto(s) seleccionada(s)'
                      : 'Toca para agregar fotos',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Dropdown para seleccionar tipo de propiedad.
  Widget _buildSelectorTipo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de propiedad',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<TipoPropiedad>(
          initialValue: _tipoSeleccionado,
          items: TipoPropiedad.values.map((tipo) {
            return DropdownMenuItem(value: tipo, child: Text(tipo.label));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _tipoSeleccionado = value);
            }
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.home_outlined),
          ),
        ),
      ],
    );
  }

  /// Placeholder del selector de mapa (RF-006).
  Widget _buildPlaceholderMapa() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona la ubicación exacta',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          height: 250, // Un poco más alto para mejor interacción
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _puntoInicial,
                zoom: 14,
              ),
              // Esto permite que el mapa capture los gestos dentro del scroll
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              onTap: (LatLng posicion) {
                setState(() {
                  _ubicacionSeleccionada = posicion;
                });
              },
              markers: _ubicacionSeleccionada == null
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('seleccion'),
                        position: _ubicacionSeleccionada!,
                      ),
                    },
            ),
          ),
        ),
        if (_ubicacionSeleccionada != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Ubicación marcada: ${_ubicacionSeleccionada!.latitude.toStringAsFixed(4)}, ${_ubicacionSeleccionada!.longitude.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),
      ],
    );
  }
}
