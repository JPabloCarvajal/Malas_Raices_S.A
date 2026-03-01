import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/custom_text_field.dart';

/// Pantalla de registro de nuevos usuarios (RF-001).
///
/// El usuario elige su rol (Propietario o Arrendatario),
/// llena sus datos y al registrarse vuelve al Login.
///
/// TODO: Conectar con backend para crear la cuenta en la BD.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();

  // Tipo de cuenta seleccionado. Por defecto es arrendatario.
  String _tipoSeleccionado = 'arrendatario';

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegistrar() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Enviar datos al backend para crear la cuenta.

      // Mostramos mensaje de éxito.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta creada exitosamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );

      // Volvemos al login para que inicie sesión.
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Selector de tipo de cuenta ───
                const Text(
                  '¿Qué tipo de cuenta necesitas?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Dos tarjetas lado a lado para elegir el rol.
                Row(
                  children: [
                    Expanded(
                      child: _buildTipoCard(
                        titulo: 'Arrendatario',
                        icono: Icons.search,
                        descripcion: 'Busco propiedades',
                        valor: 'arrendatario',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTipoCard(
                        titulo: 'Propietario',
                        icono: Icons.home_work_outlined,
                        descripcion: 'Publico propiedades',
                        valor: 'propietario',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ─── Campos del formulario ───
                CustomTextField(
                  label: 'Nombre completo',
                  hint: 'Juan Pérez',
                  controller: _nombreController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Correo electrónico',
                  hint: 'ejemplo@correo.com',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Correo no válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Teléfono de contacto',
                  hint: '3001234567',
                  controller: _telefonoController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu teléfono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Contraseña',
                  hint: '••••••••',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una contraseña';
                    }
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // ─── Botón de registro ───
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onRegistrar,
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ─── Enlace a login ───
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿Ya tienes cuenta? ',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Inicia sesión',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye una tarjeta seleccionable para el tipo de cuenta.
  /// Cambia su apariencia dependiendo de si está seleccionada o no.
  Widget _buildTipoCard({
    required String titulo,
    required IconData icono,
    required String descripcion,
    required String valor,
  }) {
    // Comparamos el valor de esta tarjeta con el seleccionado.
    final seleccionado = _tipoSeleccionado == valor;

    return GestureDetector(
      // Al tocar, actualizamos el tipo seleccionado y redibujamos.
      onTap: () => setState(() => _tipoSeleccionado = valor),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Fondo azul claro si está seleccionado, blanco si no.
          color: seleccionado
              ? AppTheme.primaryColor.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Borde azul grueso si está seleccionado, gris fino si no.
          border: Border.all(
            color: seleccionado
                ? AppTheme.primaryColor
                : const Color(0xFFE0E0E0),
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icono,
              size: 32,
              color: seleccionado
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: seleccionado
                    ? AppTheme.primaryColor
                    : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              descripcion,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
