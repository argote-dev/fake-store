class ProductEntity {
  final int productId;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String image;
  final int discount;
  final bool availability;
  final String brand;
  final String category;
  final double rating;
  final String? reviewsJson;

  ProductEntity({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.image,
    required this.discount,
    required this.availability,
    required this.brand,
    required this.category,
    required this.rating,
    this.reviewsJson,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'image': image,
      'discount': discount,
      'availability': availability ? 1 : 0,
      'brand': brand,
      'category': category,
      'rating': rating,
      'reviews_json': reviewsJson,
    };
  }

  factory ProductEntity.fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      productId: map['product_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      unit: map['unit'] as String,
      image: map['image'] as String,
      discount: map['discount'] as int,
      availability: (map['availability'] as int) == 1,
      brand: map['brand'] as String,
      category: map['category'] as String,
      rating: (map['rating'] as num).toDouble(),
      reviewsJson: map['reviews_json'] as String?,
    );
  }
}
