import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examen_final_oton_1/providers/list_provider.dart';
import 'package:examen_final_oton_1/utils/app_colors.dart';
import 'package:examen_final_oton_1/widgets/list_tile_widget.dart';
import 'package:examen_final_oton_1/widgets/empty_state_widget.dart';

/// PANTALLA DE LISTA
class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar items desde la API al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItemsWithErrorHandling();
    });
  }

  /// CARGAR ITEMS CON MANEJO DE ERRORES
  ///
  /// Intenta cargar los items desde la API y maneja posibles errores.
  Future<void> _loadItemsWithErrorHandling() async {
    try {
      await Provider.of<ListProvider>(context, listen: false).loadItems();
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error al cargar datos: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: buildAppBar(context),
      body: buildBody()
    );
  }

  /// CONSTRUCCIÓN DE LA APPBAR
  AppBar buildAppBar(BuildContext context) {
    return AppBar(title: const Text('Próximos lanzamientos'), centerTitle: true);
  }

  /// CONSTRUCCIÓN DEL CUERPO CON PULL-TO-REFRESH
  Widget buildBody() {
    return Consumer<ListProvider>(
      builder: (context, listProvider, child) {
        return RefreshIndicator(onRefresh: _refreshData, child: buildContent(listProvider));
      },
    );
  }

  /// CONSTRUCCIÓN DEL CONTENIDO PRINCIPAL
  Widget buildContent(ListProvider listProvider) {
    // Estado de carga inicial
    if (listProvider.isLoading && listProvider.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando datos desde la API...'),
          ],
        ),
      );
    }    // Estado vacío con botón de retry
    if (listProvider.isEmpty && !listProvider.isLoading) {
      return EmptyStateWidget.networkError(
        onAction: _refreshData,
      );
    }

    // Lista con datos usando el widget centralizado
    return ListView.builder(
      itemCount: listProvider.itemCount,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final item = listProvider.listItems[index];
        return ItemTileWidget(launch: item, isLoading: listProvider.isLoading);
      },
    );
  }

  /// ESTADO VACÍO CON BOTÓN DE RETRY
  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No hay elementos', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Verifica tu conexión a internet', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  /// REFRESCAR DATOS DESDE LA API
  Future<void> _refreshData() async {
    try {
      await Provider.of<ListProvider>(context, listen: false).refreshItems();
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error al refrescar: ${e.toString()}');
      }
    }
  }

  /// MOSTRAR ERROR EN SNACKBAR
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: 'Reintentar',
          textColor: Colors.white,
          onPressed: _refreshData,
        ),
      ),
    );
  }
}
