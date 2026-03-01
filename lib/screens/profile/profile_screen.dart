import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/custom_text_field.dart';

/// Pantalla de gestión de perfil del usuario (RF-003).
///
/// Permite editar: nombre, teléfono, foto de perfil.
/// El correo se muestra pero NO se puede editar (es el identificador).
///
/// TODO: Conectar con backend para guardar los cambios.
/// TODO: Implementar image_picker para cambiar foto de perfil.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Se inicializan en initState con los datos del usuario actual.
  late final TextEditingController _nombreController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefonoController;

  // Se pone en true cuando el usuario modifica algo.
  bool _modificado = false;

  @override
  void initState() {
    super.initState();
    // Precargamos los datos actuales del usuario en los campos.
    final usuario = MockData.usuarioActual;
    _nombreController = TextEditingController(text: usuario.nombre);
    _emailController = TextEditingController(text: usuario.email);
    _telefonoController = TextEditingController(text: usuario.telefono);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _onGuardar() {
    // TODO: Enviar datos actualizados al backend.
    setState(() => _modificado = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil actualizado correctamente'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = MockData.usuarioActual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          // El botón "Guardar" solo aparece si hay cambios.
          if (_modificado)
            TextButton(
              onPressed: _onGuardar,
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ─── Foto de perfil con botón de cámara ───
            Center(
              child: Stack(
                children: [
                  // Avatar circular grande.
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  // Botoncito de cámara en la esquina inferior derecha.
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Abrir image_picker para cambiar la foto.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cambio de foto próximamente'),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Chip con el tipo de cuenta (solo informativo).
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                usuario.esPropietario ? 'Propietario' : 'Arrendatario',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ─── Campo: Nombre (editable) ───
            CustomTextField(
              label: 'Nombre completo',
              controller: _nombreController,
              prefixIcon: Icons.person_outline,
              // Cada vez que el usuario escribe, activamos el flag.
              onChanged: (_) => setState(() => _modificado = true),
            ),
            const SizedBox(height: 16),

            // ─── Campo: Email (no editable) ───
            CustomTextField(
              label: 'Correo electrónico',
              controller: _emailController,
              prefixIcon: Icons.email_outlined,
              // No tiene onChanged porque no queremos que se edite.
              // Visualmente se ve igual, pero sin el callback
              // el botón "Guardar" no aparece al escribir aquí.
            ),
            const SizedBox(height: 4),
            Text(
              'El correo no se puede modificar',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),

            // ─── Campo: Teléfono (editable) ───
            CustomTextField(
              label: 'Teléfono de contacto',
              controller: _telefonoController,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              onChanged: (_) => setState(() => _modificado = true),
            ),
            const SizedBox(height: 28),

            // ─── Información de la cuenta (solo lectura) ───
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información de la cuenta',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Miembro desde: ${_formatearFecha(usuario.fechaCreacion)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    'Tipo de cuenta: ${usuario.tipoUsuario}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Convierte un DateTime a texto legible: "15 de enero, 2025".
  String _formatearFecha(DateTime fecha) {
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${fecha.day} de ${meses[fecha.month - 1]}, ${fecha.year}';
  }
}
