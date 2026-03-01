import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/property/create_property_screen.dart';
import '../screens/property/my_properties_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/profile/profile_screen.dart';

/// Rutas de navegación centralizadas.
/// En vez de escribir '/login' como string por toda la app,
/// usas AppRoutes.login. Así evitas errores de tipeo.
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String createProperty = '/create-property';
  static const String myProperties = '/my-properties';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  /// Mapa que conecta cada nombre de ruta con su pantalla.
  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      createProperty: (context) => const CreatePropertyScreen(),
      myProperties: (context) => const MyPropertiesScreen(),
      favorites: (context) => const FavoritesScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}
