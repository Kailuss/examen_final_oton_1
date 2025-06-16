import 'package:flutter/material.dart';
import 'package:examen_final_oton_1/models/launch_model.dart';
import 'package:examen_final_oton_1/providers/api_provider.dart';

/// PROVIDER DE GESTIÓN DE LISTA - USANDO API REST

class ListProvider extends ChangeNotifier {
  // Lista principal de items en memoria
  List<LaunchModel> listItems = [];

  // Estado de carga para mostrar indicadores en la UI
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// CONSTRUCTOR - CARGA AUTOMÁTICA DE DATOS
  
  ListProvider() {
    loadItems();
  }  

  /// CARGAR TODOS LOS ITEMS DESDE API

  Future<void> loadItems() async {
    try {
      _setLoading(true);

      final items = await ApiProvider.api.getAllItems();

      // Reemplazar lista completa
      listItems = [...items];

      // Notificar cambios a la UI
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene un item específico por ID (primero busca local, si no hace GET a API)
  Future<LaunchModel?> getItemById(String id) async {
    try {
      try {
        return listItems.firstWhere((item) => item.id == id);
      } catch (e) {
        return await ApiProvider.api.getItemById(id);
      }
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el número total de items
  int get itemCount => listItems.length;

  /// Verifica si la lista está vacía
  bool get isEmpty => listItems.isEmpty;

  /// Verifica si la lista tiene elementos
  bool get isNotEmpty => listItems.isNotEmpty;

  /// Obtiene una copia de la lista (para evitar modificaciones externas)
  List<LaunchModel> get items => List.unmodifiable(listItems);

  /// MANEJO DE ESTADO DE CARGA
  ///
  /// Permite mostrar indicadores de carga en la UI durante las peticiones HTTP.
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// MÉTODO HELPER - REFRESCAR DATOS
  ///
  /// Recarga todos los datos desde la API.
  /// Útil para pull-to-refresh.
  Future<void> refreshItems() async {
    await loadItems();
  }
}
