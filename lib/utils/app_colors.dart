import 'package:flutter/material.dart';

/// Helper para acceder fácilmente a los colores del ColorScheme
class AppColors {
  /// Obtiene el ColorScheme actual del contexto
  static ColorScheme of(BuildContext context) => Theme.of(context).colorScheme;

  /// Colores adicionales que no están en ColorScheme
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  static const Color backgroundGray = Color(0xFFF0F0F0);

  /// Gradientes usando los colores del tema
  static LinearGradient primaryGradient(BuildContext context) => LinearGradient(
    colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient surfaceGradient(BuildContext context) => LinearGradient(
    colors: [
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.surfaceContainerHighest,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Extensión para facilitar el acceso a los colores desde el contexto
extension ColorSchemeExtension on BuildContext {
  /// Acceso rápido al ColorScheme
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Métodos de conveniencia para colores específicos
  Color get primaryColor => colors.primary;
  Color get secondaryColor => colors.secondary;
  Color get errorColor => colors.error;
  Color get surfaceColor => colors.surface;
  Color get backgroundColor => colors.surface;

  /// Colores de texto
  Color get onPrimary => colors.onPrimary;
  Color get onSecondary => colors.onSecondary;
  Color get onSurface => colors.onSurface;
  Color get onBackground => colors.onSurface;
}
