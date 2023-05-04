// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import 'order_data.dart';

class TableData extends Equatable {
  TableData({
    required this.id,
    required this.storeId,
    required this.name,
    required this.status,
    this.orderData,
  });

  late final int id;
  late final int storeId;
  late final String name;
  late bool status;
  late OrderData? orderData;

  TableData.fromJson(dynamic json) {
    id = json['id'];
    storeId = json['storeId'];
    name = json['name'];
    status = json['status'];
    orderData = null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['storeId'] = storeId;
    map['name'] = name;
    map['status'] = status;
    return map;
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'TableData($id, $storeId, $name, $status, $orderData)';
}
