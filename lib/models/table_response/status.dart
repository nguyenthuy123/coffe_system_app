import 'package:equatable/equatable.dart';

class Status extends Equatable {
  final int? code;
  final String? message;

  const Status({this.code, this.message});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        code: json['code'] as int?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [code, message];
}
