import 'package:equatable/equatable.dart';

import 'sort.dart';

class Pageable extends Equatable {
  final Sort? sort;
  final int? offset;
  final int? pageNumber;
  final int? pageSize;
  final bool? paged;
  final bool? unpaged;

  const Pageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.paged,
    this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) => Pageable(
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        offset: json['offset'] as int?,
        pageNumber: json['pageNumber'] as int?,
        pageSize: json['pageSize'] as int?,
        paged: json['paged'] as bool?,
        unpaged: json['unpaged'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'sort': sort?.toJson(),
        'offset': offset,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'paged': paged,
        'unpaged': unpaged,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      sort,
      offset,
      pageNumber,
      pageSize,
      paged,
      unpaged,
    ];
  }
}
