import 'package:equatable/equatable.dart';

import 'item.dart';
import 'pageable.dart';
import 'sort.dart';

class ItemResponse extends Equatable {
  final List<Item>? items;
  final Pageable? pageable;
  final int? totalPages;
  final int? totalElements;
  final bool? last;
  final int? size;
  final int? number;
  final Sort? sort;
  final int? numberOfElements;
  final bool? first;
  final bool? empty;

  const ItemResponse({
    this.items,
    this.pageable,
    this.totalPages,
    this.totalElements,
    this.last,
    this.size,
    this.number,
    this.sort,
    this.numberOfElements,
    this.first,
    this.empty,
  });

  factory ItemResponse.fromJson(Map<String, dynamic> json) => ItemResponse(
        items: (json['content'] as List<dynamic>?)
            ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
            .toList(),
        pageable: json['pageable'] == null
            ? null
            : Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
        totalPages: json['totalPages'] as int?,
        totalElements: json['totalElements'] as int?,
        last: json['last'] as bool?,
        size: json['size'] as int?,
        number: json['number'] as int?,
        sort: json['sort'] == null
            ? null
            : Sort.fromJson(json['sort'] as Map<String, dynamic>),
        numberOfElements: json['numberOfElements'] as int?,
        first: json['first'] as bool?,
        empty: json['empty'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'content': items?.map((e) => e.toJson()).toList(),
        'pageable': pageable?.toJson(),
        'totalPages': totalPages,
        'totalElements': totalElements,
        'last': last,
        'size': size,
        'number': number,
        'sort': sort?.toJson(),
        'numberOfElements': numberOfElements,
        'first': first,
        'empty': empty,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      items,
      pageable,
      totalPages,
      totalElements,
      last,
      size,
      number,
      sort,
      numberOfElements,
      first,
      empty,
    ];
  }
}
