import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? employeeId;
  final int? storeId;
  final String? storeName;
  final String? username;
  final String? name;
  final String? role;
  final String? accessToken;
  final String? refreshToken;

  const User({
    this.employeeId,
    this.storeId,
    this.storeName,
    this.username,
    this.name,
    this.role,
    this.accessToken,
    this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        employeeId: json['employeeId'] as int?,
        storeId: json['storeId'] as int?,
        storeName: json['storeName'] as String?,
        username: json['username'] as String?,
        name: json['name'] as String?,
        role: json['role'] as String?,
        accessToken: json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'storeId': storeId,
        'storeName': storeName,
        'username': username,
        'name': name,
        'role': role,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      employeeId,
      storeId,
      storeName,
      username,
      name,
      role,
      accessToken,
      refreshToken,
    ];
  }
}
