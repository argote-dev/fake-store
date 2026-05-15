import '../../domain/models/category.dart';
import '../models/entity/category_entity.dart';

class CategoryMapper {
  static Category fromEntityToDomain(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
      image: _getCategoryImage(entity.name),
    );
  }

  static CategoryEntity fromDomainToEntity(Category domain) {
    return CategoryEntity(
      id: domain.id,
      name: domain.name,
    );
  }

  static String _getCategoryImage(String categoryName) {
    switch (categoryName) {
      case 'Electronics':
        return 'assets/images/electronics.jpg';
      case 'Wearables':
        return 'assets/images/wearable.jpg';
      case 'Cameras':
        return 'assets/images/cameras.jpg';
      case 'Gaming':
        return 'assets/images/gaming.jpg';
      case 'Appliances':
        return 'assets/images/appliances.jpg';
      default:
        return 'assets/images/electronics.jpg';
    }
  }
}
