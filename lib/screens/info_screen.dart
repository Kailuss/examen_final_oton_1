import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          orElse: () => launch, // Si no se encuentra, usar el original
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
                // Imagen del producto con efecto de sombra y bordes redondeados
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(color: theme.colorScheme.primary.withAlpha(25)),
                  child: Hero(
                    tag: 'launch-image-${currentItem.id}',
                    child: currentItem.image != null && currentItem.image!.isNotEmpty
                        ? ClipRRect(
                            child: Image.network(
                              currentItem.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                            child: const Icon(Icons.computer, size: 100, color: Colors.grey),
                          ),
                  ),
                ),

                // Información del producto
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título, año y precio
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentItem.name,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                if (currentItem.lspName != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    currentItem.lspName.toString(),
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Descripción
                      const SizedBox(height: 16),
                      Text(
                        currentItem.status.description!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
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
}
