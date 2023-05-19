import 'package:equatable/equatable.dart';

import 'table.dart';
import 'status.dart';

class TableResponse extends Equatable {
  final Status? status;
  final List<Table>? tables;

  const TableResponse({this.status, this.tables});

  factory TableResponse.fromJson(Map<String, dynamic> json) => TableResponse(
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
        tables: (json['data'] as List<dynamic>?)
            ?.map((e) => Table.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status?.toJson(),
        'data': tables?.map((e) => e.toJson()).toList(),
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [status, tables];
}
