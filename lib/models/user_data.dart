// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  UserData({
    required this.code,
    required this.id,
    required this.storeId,
    required this.username,
    required this.name,
    required this.accessToken,
  });

  late final int code;
  late final int id;
  late final int storeId;
  late final String username;
  late final String name;
  late final String accessToken;

  UserData.fromJson(dynamic json) {
    code = json['status']['code'];
    id = json['data']['employeeId'];
    storeId = json['data']['storeId'];
    username = json['data']['username'];
    name = json['data']['name'];
    accessToken = json['data']['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['id'] = id;
    map['storeId'] = storeId;
    map['username'] = username;
    map['name'] = name;
    map['accessToken'] = accessToken;
    return map;
  }

  @override
  String toString() =>
      'User($code, $id, $storeId, $username, $name, $accessToken)';

  @override
  List<Object?> get props => [id];
}
