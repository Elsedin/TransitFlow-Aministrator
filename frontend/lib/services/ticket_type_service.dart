import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/ticket_type_model.dart';
import 'auth_service.dart';

class TicketTypeService {
  Future<List<TicketType>> getAll({bool? isActive}) async {
    try {
      final token = await AuthService().getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      var queryParams = <String, String>{};
      if (isActive != null) {
        queryParams['isActive'] = isActive.toString();
      }

      final uri = Uri.parse('${AppConfig.apiBaseUrl}/tickettypes')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TicketType.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load ticket types');
      }
    } catch (e) {
      throw Exception('Failed to load ticket types: $e');
    }
  }
}
