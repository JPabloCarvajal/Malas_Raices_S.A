import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/custom_text_field.dart';

/// Pantalla de inicio de sesión (RF-002).
///
/// Por ahora no valida contra una base de datos real.
/// Al presionar "Iniciar sesión" simplemente navega al Home.
///
/// TODO: Conectar con autenticación real cuando haya backend.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para leer el texto de cada campo.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Llave del formulario para validar todos los campos de golpe.
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // SIEMPRE liberar los controladores al destruir la pantalla.
    // Si no haces esto, se quedan en memoria sin motivo (memory leak).
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Se ejecuta al presionar el botón "Iniciar sesión".
  void _onLogin() {
    // validate() recorre todos los campos del Form y ejecuta sus validators.
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Aquí iría la llamada al servicio de autenticación.
      // Por ahora navegamos directo al Home.
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sin AppBar para que se vea como pantalla de bienvenida limpia.
      body: SafeArea(
        // SafeArea evita que el contenido se meta debajo del notch o la barra de estado.
        child: Center(
          child: SingleChildScrollView(
            // SingleChildScrollView: si el teclado cubre los campos,
            // el usuario puede hacer scroll para verlos. Sin esto,
            // los campos de abajo quedarían tapados.
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ─── Logo e identidad visual ───
                  Icon(
                    Icons.home_work_rounded,
                    size: 72,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'MalasRaíces',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Gestión de propiedades en arriendo',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ─── Campo de correo ───
                  CustomTextField(
                    label: 'Correo electrónico',
                    hint: 'ejemplo@correo.com',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo electrónico';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ─── Campo de contraseña ───
                  CustomTextField(
                    label: 'Contraseña',
                    hint: '••••••••',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                    obscureText: true, // Oculta el texto con puntos.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // ─── Botón de iniciar sesión ───
                  SizedBox(
                    width: double.infinity, // Ocupa todo el ancho disponible.
                    child: ElevatedButton(
                      onPressed: _onLogin,
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ─── Enlace a registro ───
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿No tienes cuenta? ',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () {
                          // pushNamed (sin Replacement) porque desde registro
                          // SÍ queremos poder volver al login con "atrás".
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
