// ignore_for_file: must_be_immutable

import 'package:datn/models/table_response/order.dart';
import 'package:equatable/equatable.dart';

class Table extends Equatable {
  final int? id;
  final String? name;
  final int? storeId;
  bool? status;
  Order? order;

  Table({
    this.id,
    this.name,
    this.storeId,
    this.status,
    this.order,
  });

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        id: json['id'] as int?,
        name: json['name'] as String?,
        storeId: json['storeId'] as int?,
        status: json['status'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'storeId': storeId,
        'status': status,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, storeId, status, order];
}
