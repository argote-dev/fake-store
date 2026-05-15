import '../../domain/models/category.dart';
import '../models/entity/category_entity.dart';

class CategoryMapper {
  static Category fromEntityToDomain(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
    );
  }

  static CategoryEntity fromDomainToEntity(Category domain) {
    return CategoryEntity(
      id: domain.id,
      name: domain.name,
    );
  }
}
