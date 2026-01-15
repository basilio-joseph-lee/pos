class Store {
  final String? id;
  final String name;
  final String manager;
  final String location;
  final String phone;
  final String status;

  Store({
    this.id,
    required this.name,
    required this.manager,
    required this.phone,
    required this.status,
    required this.location,
  });

  factory Store.fromJson(Map<String, dynamic> data) {
    return Store(
      id: data['storeID'],
      name: data['Name'],
      manager: data['Manager'],
      phone: data['Phone'],
      status: data['Status'],
      location: data['Location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'storeID': id,
      'Name': name,
      'Manager': manager,
      'Location': location,
      'Phone': phone,
      'Status': status,
    };
  }
}
