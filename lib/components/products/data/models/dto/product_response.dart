class ProductResponse {
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
  final List<ReviewResponse>? reviews;

  ProductResponse({
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
    this.reviews,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      productId: json['product_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      unit: json['unit'] as String,
      image: json['image'] as String,
      discount: json['discount'] as int,
      availability: json['availability'] as bool,
      brand: json['brand'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'image': image,
      'discount': discount,
      'availability': availability,
      'brand': brand,
      'category': category,
      'rating': rating,
      'reviews': reviews?.map((e) => e.toJson()).toList(),
    };
  }
}

class ReviewResponse {
  final int userId;
  final int rating;
  final String comment;

  ReviewResponse({
    required this.userId,
    required this.rating,
    required this.comment,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      userId: json['user_id'] as int,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'rating': rating,
      'comment': comment,
    };
  }
}
