import 'package:datn/models/item_response/item.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.name,
    required this.items,
  });

  final int id;
  final String name;
  final List<Item> items;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id];
}
