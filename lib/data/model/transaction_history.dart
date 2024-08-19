class TransactionHistory {
  String? name;
  String? phone;
  String? address;
  Map<String, dynamic>? items;

  TransactionHistory({
    this.name,
    this.phone,
    this.address,
    this.items,
  });

  TransactionHistory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    items = json['cartItems'];
  }
}