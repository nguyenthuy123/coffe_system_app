import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int? id;
  final String? name;
  final String? phone;
  final int? point;
  final DateTime? createTime;

  const Customer({
    this.id,
    this.name,
    this.phone,
    this.point,
    this.createTime,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      point: json['point'] as int?,
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'point': point,
        'createTime': createTime?.toIso8601String(),
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, phone, point, createTime];
}
