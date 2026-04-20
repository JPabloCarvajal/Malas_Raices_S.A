import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/usuario.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';

/// Pantalla de gestión de perfil del usuario (RF-003).
/// Permite editar: nombre, teléfono, foto de perfil.
/// El correo NO se puede editar (es el identificador).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();

  // Controladores se crean cuando cargamos el usuario.
  TextEditingController? _nombreController;
  TextEditingController? _emailController;
  TextEditingController? _telefonoController;

  Usuario? _usuario;
  bool _cargando = true;
  bool _modificado = false;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  @override
  void dispose() {
    _nombreController?.dispose();
    _emailController?.dispose();
    _telefonoController?.dispose();
    super.dispose();
  }

  /// Carga el usuario desde SharedPreferences primero (instantáneo)
  /// y luego intenta refrescarlo contra el backend.
  Future<void> _cargarPerfil() async {
    setState(() => _cargando = true);

    // 1. Usuario cacheado (si existe) → mostramos rápido.
    final cacheado = await _authService.getUsuarioLocal();
    if (cacheado != null && mounted) {
      _aplicarUsuario(cacheado);
      setState(() => _cargando = false);
    }

    // 2. Refrescamos con el backend.
    try {
      final fresco = await _authService.getPerfil();
      if (!mounted) return;
      _aplicarUsuario(fresco);
    } catch (e) {
      // Si hay caché, no mostramos error. Si no hay caché, sí.
      if (cacheado == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  /// Asigna el usuario a los controladores de texto.
  void _aplicarUsuario(Usuario usuario) {
    setState(() {
      _usuario = usuario;
      _nombreController?.text = usuario.nombre;
      _nombreController ??= TextEditingController(text: usuario.nombre);
      _emailController?.text = usuario.email;
      _emailController ??= TextEditingController(text: usuario.email);
      _telefonoController?.text = usuario.telefono;
      _telefonoController ??= TextEditingController(text: usuario.telefono);
      _modificado = false;
    });
  }

  /// Envía los cambios al backend.
  /// TODO: crear endpoint PUT /auth/perfil y método en AuthService.
  Future<void> _onGuardar() async {
    setState(() => _guardando = true);
    try {
      await _authService.actualizarPerfil(
        nombre: _nombreController!.text.trim(),
        telefono: _telefonoController!.text.trim(),
      );
      if (!mounted) return;
      setState(() => _modificado = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cargando por primera vez, sin caché.
    if (_cargando && _usuario == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi perfil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Si no hay usuario (error + sin caché), mostramos fallback.
    if (_usuario == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi perfil')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 12),
              const Text('No se pudo cargar el perfil'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _cargarPerfil,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final usuario = _usuario!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          if (_modificado)
            TextButton(
              onPressed: _guardando ? null : _onGuardar,
              child: _guardando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Guardar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarPerfil,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ─── Foto de perfil ───
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
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

              // Chip del tipo de cuenta.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
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

              // ─── Nombre (editable) ───
              CustomTextField(
                label: 'Nombre completo',
                controller: _nombreController,
                prefixIcon: Icons.person_outline,
                onChanged: (_) => setState(() => _modificado = true),
              ),
              const SizedBox(height: 16),

              // ─── Email (no editable) ───
              CustomTextField(
                label: 'Correo electrónico',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 4),
              Text(
                'El correo no se puede modificar',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const SizedBox(height: 16),

              // ─── Teléfono (editable) ───
              CustomTextField(
                label: 'Teléfono de contacto',
                controller: _telefonoController,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: (_) => setState(() => _modificado = true),
              ),
              const SizedBox(height: 28),

              // ─── Info de la cuenta ───
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
      ),
    );
  }

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
