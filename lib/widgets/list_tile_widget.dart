import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:examen_final_oton_1/models/launch_model.dart';
import 'package:examen_final_oton_1/screens/info_screen.dart';

/// WIDGET REUTILIZABLE - TARJETA DE ITEM
///
/// Este widget maneja toda la presentación visual de cada launch en la lista.
/// Centraliza el diseño, la lógica de imágenes, estados de carga y navegación.
class ItemTileWidget extends StatelessWidget {
  final LaunchModel launch;
  final bool isLoading;
  final VoidCallback? onTap;

  const ItemTileWidget({super.key, required this.launch, this.isLoading = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildLeadingWidget(context),
        title: Text(launch.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        subtitle: _buildSubtitle(context),
        trailing: _buildTrailingWidget(context),
        onTap: isLoading ? null : (onTap ?? () => _navigateToInfo(context)),
      ),
    );
  }

  /// WIDGET LEADING - IMAGEN O ICONO
  Widget _buildLeadingWidget(BuildContext context) {
    if (launch.image != null && launch.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          launch.image!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildDefaultIcon(context);
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon(context);
          },
        ),
      );
    } else {
      return _buildDefaultIcon(context);
    }
  }

  /// ICONO POR DEFECTO
  Widget _buildDefaultIcon(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.rocket_launch_rounded,
        size: 32,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  /// SUBTÍTULO CON INFORMACIÓN
  Widget _buildSubtitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),        Text(
          '${launch.name} • ${_formatDate(launch.net)}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// WIDGET TRAILING - INDICADOR DE CARGA O FLECHA
  Widget _buildTrailingWidget(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
  /// NAVEGACIÓN A PANTALLA DE INFORMACIÓN
  void _navigateToInfo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen(launch: launch)));
  }

  /// FORMATEAR FECHA
  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(date);
  }
}
