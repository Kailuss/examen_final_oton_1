import 'dart:convert';
import 'package:examen_final_oton_1/models/launch_model.dart';
import 'package:http/http.dart' as http;

/// Proveedor de API

class ApiProvider {
  // URL base
  static const String baseUrl = 'https://ll.thespacedevs.com/2.2.0';
  // Endpoints específicos
  static const String itemsEndpoint = '/launch/upcoming/';
  // Singleton pattern
  static final ApiProvider api = ApiProvider._();
  ApiProvider._();

  /// OBTENER TODOS LOS ITEMS

  Future<List<LaunchModel>> getAllItems() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$itemsEndpoint'), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        
        final List<dynamic> jsonList = json.decode(response.body);
        print(jsonList);

        // Convertir datos de la API al formato de nuestro modelo
        final List<LaunchModel> items = jsonList.map((json) {
          return _mapApiDataToLaunchModel(json);
        }).toList();

        return items;
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // En caso de error, devolver lista vacía o lanzar excepción
      throw Exception('Error de conexión: $e');
    }
  }

  /// OBTENER ITEM POR ID
  Future<LaunchModel?> getItemById(String id) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl$itemsEndpoint/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Verificar si la respuesta tiene contenido antes de intentar decodificar
        if (response.body.isEmpty) return null;

        final Map<String, dynamic> responseData = json.decode(response.body);
        final LaunchModel item = _mapApiDataToLaunchModel(responseData);
        return item;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      return null;
    }
  }

  /// MAPEAR DATOS DE API A LAUNCH MODEL
  LaunchModel _mapApiDataToLaunchModel(Map<String, dynamic> apiData) {
    return LaunchModel(
      // CrudCrud.com usa '_id' como campo de identificación único
      // Ignoramos el campo 'id' si existe para evitar confusiones
      id: apiData['_id']?.toString() ?? '0',
      name: apiData['name'] ?? 'Sin nombre',
      status: apiData['status'] ?? 'Sin estado',
      net: apiData['net'] ?? 'Sin fecha',
      lspName : apiData['lspName'] ?? 'Sin agencia',
      image: apiData['image'] ?? 'https://via.placeholder.com/150',
    );
  }


  Map<String, dynamic> _mapLaunchModelToApiData(LaunchModel item) {
    return {
      'id': item.id,
      'name': item.name,
      'status': item.status,
      'net': item.net,
      'lspName': item.lspName,
      'pad': item.pad,
      'image': item.image,
    };
  }
}
