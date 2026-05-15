import 'dart:convert';
import '../../domain/models/product.dart';
import '../../domain/models/review.dart';
import '../models/dto/product_response.dart';
import '../models/entity/product_entity.dart';

class ProductMapper {
  static Product fromDtoToDomain(ProductResponse dto) {
    return Product(
      productId: dto.productId,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      unit: dto.unit,
      image: dto.image,
      discount: dto.discount,
      availability: dto.availability,
      brand: dto.brand,
      category: dto.category,
      rating: dto.rating,
      reviews: dto.reviews?.map((e) => fromReviewDtoToDomain(e)).toList(),
    );
  }

  static Review fromReviewDtoToDomain(ReviewResponse dto) {
    return Review(
      userId: dto.userId,
      rating: dto.rating,
      comment: dto.comment,
    );
  }

  static ProductEntity fromDtoToEntity(ProductResponse dto) {
    return ProductEntity(
      productId: dto.productId,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      unit: dto.unit,
      image: dto.image,
      discount: dto.discount,
      availability: dto.availability,
      brand: dto.brand,
      category: dto.category,
      rating: dto.rating,
      reviewsJson: dto.reviews != null ? jsonEncode(dto.reviews!.map((e) => e.toJson()).toList()) : null,
    );
  }

  static Product fromEntityToDomain(ProductEntity entity) {
    List<Review>? reviews;
    if (entity.reviewsJson != null) {
      final List<dynamic> decoded = jsonDecode(entity.reviewsJson!);
      reviews = decoded
          .map((e) => fromReviewDtoToDomain(ReviewResponse.fromJson(e as Map<String, dynamic>)))
          .toList();
    }

    return Product(
      productId: entity.productId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      unit: entity.unit,
      image: entity.image,
      discount: entity.discount,
      availability: entity.availability,
      brand: entity.brand,
      category: entity.category,
      rating: entity.rating,
      reviews: reviews,
    );
  }
}
