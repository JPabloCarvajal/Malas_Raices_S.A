import 'package:flutter/material.dart';

/// Campo de texto reutilizable para toda la aplicación.
///
/// Se usa en: Login, Registro, Crear Propiedad, Perfil.
/// Así todos los campos de texto se ven igual sin repetir código.
class CustomTextField extends StatelessWidget {
  final String label; // Texto que aparece ARRIBA del campo
  final String? hint; // Texto gris dentro del campo (placeholder)
  final TextEditingController?
  controller; // Para leer lo que escribió el usuario
  final IconData? prefixIcon; // Ícono a la izquierda (opcional)
  final bool obscureText; // true para campos de contraseña (oculta el texto)
  final TextInputType
  keyboardType; // Tipo de teclado (email, número, texto, etc.)
  final int maxLines; // Líneas del campo (1 = normal, >1 = textarea)
  final String? Function(String?)? validator; // Función de validación
  final void Function(String)?
  onChanged; // Se ejecuta cada vez que cambia el texto

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // CrossAxisAlignment.start = el contenido se alinea a la izquierda.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // La etiqueta descriptiva arriba del campo.
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 6), // Pequeño espacio entre label y campo.
        // El campo de texto en sí.
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            // Si se pasó un ícono, lo muestra a la izquierda.
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          ),
          // El estilo del borde, fondo, etc. viene del theme.dart
          // (inputDecorationTheme) que configuramos en la Parte 3.
          // Por eso no necesitamos repetirlo aquí.
        ),
      ],
    );
  }
}
