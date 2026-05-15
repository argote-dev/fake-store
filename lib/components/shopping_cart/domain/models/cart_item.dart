class CartItem {
  final int productId;
  final String name;
  final String image;
  final double price;
  final String unit;
  final int quantity;
  final bool isExpress;

  CartItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.unit,
    required this.quantity,
    required this.isExpress,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      name: name,
      image: image,
      price: price,
      unit: unit,
      quantity: quantity ?? this.quantity,
      isExpress: isExpress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'name': name,
      'image': image,
      'price': price,
      'unit': unit,
      'quantity': quantity,
      'is_express': isExpress ? 1 : 0,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['product_id'],
      name: map['name'],
      image: map['image'],
      price: map['price'],
      unit: map['unit'],
      quantity: map['quantity'],
      isExpress: map['is_express'] == 1,
    );
  }
}
