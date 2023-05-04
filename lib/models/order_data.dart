import 'package:datn/models/item_data.dart';
import 'package:equatable/equatable.dart';

class OrderData extends Equatable {
  const OrderData({
    required this.id,
    required this.name,
    required this.itemDatas,
  });

  final int id;
  final String name;
  final List<ItemData> itemDatas;

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'Order($id, $name, $itemDatas)';
}
