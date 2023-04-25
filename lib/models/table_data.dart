// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:equatable/equatable.dart';

import 'order_data.dart';

class TableData extends Equatable {
  TableData({
    required this.id,
    required this.name,
    required this.status,
    required this.orderData,
  });

  final int id;
  final String name;
  bool status;
  OrderData? orderData;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'TableData($id, $name, $status, $orderData)';
}
