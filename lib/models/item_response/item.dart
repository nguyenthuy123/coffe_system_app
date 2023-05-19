// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String? name;
  final int? id;
  final DateTime? createTime;
  final int? categoryId;
  final int? price;
  final String? categoryName;
  int qty;

  Item({
    this.name,
    this.id,
    this.createTime,
    this.categoryId,
    this.price,
    this.categoryName,
    this.qty = 0,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json['name'] as String?,
        id: json['id'] as int?,
        createTime: json['createTime'] == null
            ? null
            : DateTime.parse(json['createTime'] as String),
        categoryId: json['categoryId'] as int?,
        price: json['price'] as int?,
        categoryName: json['categoryName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'createTime': createTime?.toIso8601String(),
        'categoryId': categoryId,
        'price': price,
        'categoryName': categoryName,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      name,
      id,
      createTime,
      categoryId,
      price,
      categoryName,
    ];
  }
}
