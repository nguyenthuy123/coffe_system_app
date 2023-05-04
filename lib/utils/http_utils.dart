// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user_data.dart';
import '../models/table_data.dart';

class HttpUtils {
  static String baseUrl = 'https://coffesystem-production.up.railway.app';

  static Future<String> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json'
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> getItemDatas(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/item/list'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> getTableDatas(String token, int storeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$storeId/table/list'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> saveOrder(UserData userData, TableData tableData) async {
    try {
      final dataset = <String, dynamic>{
        'listItemRequest': [],
        'tableId': tableData.id,
        'employeeId': userData.id,
      };

      for (var el in tableData.orderData!.itemDatas) {
        (dataset['listItemRequest'] as List<dynamic>).add({
          'id': el.id,
          'quantity': el.qty,
        });
      }

      final response = await http.post(
        Uri.parse('$baseUrl/${userData.storeId}/order/save'),
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${userData.accessToken}',
        },
        body: jsonEncode(dataset),
      );

      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
