class CustomerData {
  CustomerData({required this.name, required this.phone});

  late String name;
  late String phone;

  CustomerData.fromJson(dynamic json) {
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['phone'] = phone;
    return map;
  }

  @override
  String toString() => 'CustomerData($name, $phone)';
}
