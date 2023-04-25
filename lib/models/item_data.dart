// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:equatable/equatable.dart';

class ItemData extends Equatable {
  ItemData({
    required this.id,
    required this.name,
    required this.price,
    this.qty = 0,
  });

  final int id;
  final String name;
  final double price;
  int qty;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'ItemData($id, $name, $price, $qty)';
}
