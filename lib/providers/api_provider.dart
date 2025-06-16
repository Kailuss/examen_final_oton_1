import 'dart:convert';
import 'package:examen_final_oton_1/models/launch_model.dart';
import 'package:flutter/services.dart';
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
      //final response = await http
      //    .get(Uri.parse('$baseUrl$itemsEndpoint'), headers: {'Content-Type': 'application/json'})
      //    .timeout(const Duration(seconds: 10));

      final String response = await rootBundle.loadString("assets/data.json");

      //if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response);
        final List<dynamic> jsonList = responseData['results'] ?? [];

        // Convertir datos de la API al formato de nuestro modelo
        final List<LaunchModel> items = jsonList.map((json) {
          return LaunchModel.fromMap(json as Map<String, dynamic>);
        }).toList();

        return items;
      //} else {
       /// }
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
        final LaunchModel item = LaunchModel.fromMap(responseData);
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
}
