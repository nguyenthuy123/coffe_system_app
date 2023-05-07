class CustomerData {
  CustomerData({this.id, required this.name, required this.phone});

  late int? id;
  late String name;
  late String phone;

  CustomerData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    return map;
  }

  @override
  String toString() => 'CustomerData($id, $name, $phone)';
}
