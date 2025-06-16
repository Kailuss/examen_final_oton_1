import 'package:flutter/material.dart';

/// Widget reutilizable que muestra un estado vacío con ícono y mensaje
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  /// Constructor específico para cuando no hay items
  const EmptyStateWidget.noItems({
    super.key,
    this.subtitle,
    this.onAction,
    this.actionLabel,
  }) : icon = Icons.inventory_2_outlined,
       title = 'No hay items para mostrar';

  /// Constructor específico para errores de conexión
  const EmptyStateWidget.networkError({
    super.key,
    this.subtitle = 'Verifica tu conexión a internet',
    this.onAction,
    this.actionLabel = 'Reintentar',
  }) : icon = Icons.wifi_off_rounded,
       title = 'Error de conexión';

  /// Constructor específico para resultados de búsqueda vacíos
  const EmptyStateWidget.noResults({
    super.key,
    this.subtitle = 'Intenta con otros criterios de búsqueda',
    this.onAction,
    this.actionLabel,
  }) : icon = Icons.search_off_rounded,
       title = 'Sin resultados';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.withAlpha(178), // 0.7 * 255
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
