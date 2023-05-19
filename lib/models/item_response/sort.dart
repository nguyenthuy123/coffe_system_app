import 'package:equatable/equatable.dart';

class Sort extends Equatable {
  final bool? empty;
  final bool? sorted;
  final bool? unsorted;

  const Sort({this.empty, this.sorted, this.unsorted});

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        empty: json['empty'] as bool?,
        sorted: json['sorted'] as bool?,
        unsorted: json['unsorted'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'empty': empty,
        'sorted': sorted,
        'unsorted': unsorted,
      };

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [empty, sorted, unsorted];
}
