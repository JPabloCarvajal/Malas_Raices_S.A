import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

/// Widget raíz de la aplicación.
class MalasRaicesApp extends StatelessWidget {
  const MalasRaicesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MalasRaíces',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
