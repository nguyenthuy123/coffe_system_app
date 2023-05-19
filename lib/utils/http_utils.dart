import 'dart:convert';

import 'package:datn/models/customer_response/customer.dart';
import 'package:datn/models/item_response/item_response.dart';
import 'package:datn/models/table_response/table.dart';
import 'package:datn/models/table_response/table_response.dart';
import 'package:datn/models/user_response/user.dart';
import 'package:datn/models/user_response/user_response.dart';
import 'package:http/http.dart' as http;

class HttpUtils {
  // static String baseUrl = 'http://localhost:8080';
  static String baseUrl = 'https://coffesystem-production.up.railway.app';

  static Future<UserResponse?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    return response.statusCode == 200
        ? UserResponse.fromJson(jsonDecode(response.body))
        : null;
  }

  static Future<bool> logout(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout?token=${user.accessToken}'),
    );

    return response.statusCode == 200;
  }

  static Future<TableResponse?> getTables(User user) async {
    final response = await http.get(
      Uri.parse('$baseUrl/${user.storeId}/table/list'),
      headers: {'Authorization': 'Bearer ${user.accessToken}'},
    );

    return response.statusCode == 200
        ? TableResponse.fromJson(jsonDecode(response.body))
        : null;
  }

  static Future<ItemResponse?> getItems(User user) async {
    final response = await http.get(
      Uri.parse('$baseUrl/item/list'),
      headers: {'Authorization': 'Bearer ${user.accessToken}'},
    );

    return response.statusCode == 200
        ? ItemResponse.fromJson(jsonDecode(response.body))
        : null;
  }

  static Future<bool> saveOrder(User user, Table table) async {
    final dataset = <String, dynamic>{
      'listItemRequest': [],
      'tableId': table.id,
      'employeeId': user.employeeId,
    };

    for (var el in table.order!.items) {
      (dataset['listItemRequest'] as List<dynamic>).add({
        'id': el.id,
        'quantity': el.qty,
      });
    }

    final response = await http.post(
      Uri.parse('$baseUrl/${user.storeId}/order/save'),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${user.accessToken}',
      },
      body: jsonEncode(dataset),
    );

    return response.statusCode == 200;
  }

  static Future<List<Customer>> getCustomers(User user) async {
    final response = await http.get(
      Uri.parse('$baseUrl/customer/list'),
      headers: {'Authorization': 'Bearer ${user.accessToken}'},
    );

    return (jsonDecode(response.body) as List<dynamic>)
        .map((el) => Customer.fromJson(el as Map<String, dynamic>))
        .toList();
  }

  static Future<bool> saveCustomer(User user, Customer customer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/customer/save'),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${user.accessToken}',
      },
      body: jsonEncode(customer),
    );

    return response.statusCode == 200;
  }

  static Future<bool> payOrders(User user, Table table, Customer? customer,
      [String paymentMethod = 'CASH']) async {
    final response = await http.post(
      Uri.parse('$baseUrl/${table.storeId}/bill/save'),
      headers: {
        'Accept': 'application/json',
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${user.accessToken}',
      },
      body: jsonEncode({
        'tableId': table.id,
        'customerId': customer?.id,
        'employeeId': user.employeeId,
        'paymentMethod': paymentMethod,
      }),
    );

    return response.statusCode == 200;
  }
}
