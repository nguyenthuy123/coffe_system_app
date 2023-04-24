// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:equatable/equatable.dart';

import 'order_data.dart';

class TableData extends Equatable {
  TableData({
    required this.name,
    this.status = true,
    required this.orders,
  });

  String name;
  bool status;
  List<OrderData> orders;

  @override
  String toString() {
    return '$name $status';
  }

  @override
  List<Object?> get props => [name, status];
}
