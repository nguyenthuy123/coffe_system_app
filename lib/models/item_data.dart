// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class ItemData extends Equatable {
  ItemData({
    required this.id,
    required this.name,
    required this.price,
    this.qty = 0,
  });

  late final int id;
  late final String name;
  late final int price;
  late int qty;

  ItemData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    qty = 0;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['price'] = price;
    return map;
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'ItemData($id, $name, $price, $qty)';
}
