import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:examen_final_oton_1/providers/list_provider.dart';
import 'package:examen_final_oton_1/models/launch_model.dart';
import 'package:examen_final_oton_1/utils/app_colors.dart';

/// Pantalla que muestra la información de un launch y permite editarlo o eliminarlo.
/// Usa Consumer'<'ListProvider'>' para actualizarse automáticamente cuando el launch cambia.
class InfoScreen extends StatelessWidget {
  final LaunchModel launch;

  const InfoScreen({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ListProvider>(
      builder: (context, listProvider, child) {
        // Buscar el ítem actualizado en la lista del provider
        final currentItem = listProvider.listItems.firstWhere(
          (i) => i.id == launch.id,
          orElse: () => launch,
        );
        return Scaffold(
          backgroundColor: AppColors.backgroundGray,
          appBar: AppBar(
            title: Text(currentItem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: 'launch-image-${currentItem.id}',
                          child: currentItem.image != null && currentItem.image!.isNotEmpty
                              ? ClipRRect(
                                  child: Image.network(
                                    currentItem.image!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surfaceVariant,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.rocket_launch,
                                              size: 80,
                                              color: theme.colorScheme.primary.withOpacity(0.5),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Imagen no disponible',
                                              style: TextStyle(
                                                color: theme.colorScheme.onSurfaceVariant,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surfaceVariant,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceVariant,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.rocket_launch,
                                          size: 80,
                                          color: theme.colorScheme.primary.withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Imagen no disponible',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurfaceVariant,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentItem.name,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildStatusChip(currentItem.status, theme),
                      const SizedBox(height: 24),

                      _buildInfoCard(
                        title: 'Información del Lanzamento',
                        children: [
                          _buildInfoRow(
                            icon: Icons.access_time,
                            label: 'Fecha y Hora',
                            value: _formatDate(currentItem.net),
                            theme: theme,
                          ),
                          if (currentItem.lspName != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              icon: Icons.business,
                              label: 'Proveedor',
                              value: currentItem.lspName!,
                              theme: theme,
                            ),
                          ],
                          if (currentItem.pad != null) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              icon: Icons.location_on,
                              label: 'Plataforma',
                              value: currentItem.pad!,
                              theme: theme,
                            ),
                          ],
                        ],
                        theme: theme,
                      ),

                      const SizedBox(height: 20),

                      if (currentItem.status.description.isNotEmpty)
                        _buildInfoCard(
                          title: 'Descripción del Estado',
                          children: [
                            Text(
                              currentItem.status.description,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.6,
                              ),
                            ),
                          ],
                          theme: theme,
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(Status status, ThemeData theme) {
    Color statusColor;
    IconData statusIcon;

    statusColor = Colors.green;
    statusIcon = Icons.info;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 18, color: statusColor),
          const SizedBox(width: 8),
          Text(
            status.name,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
    required ThemeData theme,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// FORMATEA FECHA
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(date);
  }
}
