import 'package:flutter/material.dart';
import 'package:examen_final_oton_1/models/launch_model.dart';
import 'package:examen_final_oton_1/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:examen_final_oton_1/providers/list_provider.dart';
import 'package:examen_final_oton_1/providers/ui_provider.dart';

/// Punto de entrada de la aplicación Flutter.
void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ListProvider()),
      ChangeNotifierProvider(create: (_) => UIProvider()),
    ],
    child: const MyApp(),
  ),
);

/// Clase principal de la aplicación que define las rutas y el tema.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Application',
      initialRoute: 'home',      routes: {
        'home': (_) => const ListScreen(),
        'info': (context) {
          final item = ModalRoute.of(context)!.settings.arguments as LaunchModel;
          return InfoScreen(launch: item);
        },
      },
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          // Colores principales
          primary: Color(0xFF2196F3),
          onPrimary: Colors.white,
          // Colores secundarios
          secondary: Color(0xFFFF9800),
          onSecondary: Colors.white,
          // Colores de fondo
          surface: Colors.white,
          onSurface: Colors.black87,
          // Colores de error
          error: Color(0xFFE91E63),
          onError: Colors.white,
        ),
        // Configuración adicional del tema
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }
}
