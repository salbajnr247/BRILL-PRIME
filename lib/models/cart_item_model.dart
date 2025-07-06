
class CartItem {
  final String id;
  final String commodityId;
  final String name;
  final String image;
  final double price;
  int quantity;
  final String vendorId;
  final String vendorName;
  final Map<String, dynamic>? metadata;

  CartItem({
    required this.id,
    required this.commodityId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.vendorId,
    required this.vendorName,
    this.metadata,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commodityId': commodityId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'metadata': metadata,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      commodityId: json['commodityId'],
      name: json['name'],
      image: json['image'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      vendorId: json['vendorId'],
      vendorName: json['vendorName'],
      metadata: json['metadata'],
    );
  }

  CartItem copyWith({
    String? id,
    String? commodityId,
    String? name,
    String? image,
    double? price,
    int? quantity,
    String? vendorId,
    String? vendorName,
    Map<String, dynamic>? metadata,
  }) {
    return CartItem(
      id: id ?? this.id,
      commodityId: commodityId ?? this.commodityId,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      metadata: metadata ?? this.metadata,
    );
  }
}
