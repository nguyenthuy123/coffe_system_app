// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:equatable/equatable.dart';

class OrderData extends Equatable {
  OrderData({
    required this.name,
    required this.cost,
    required this.count,
  });

  String name;
  double cost;
  int count;

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [name, cost];
}
