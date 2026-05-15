import 'package:go_router/go_router.dart';
import 'presentation/screens/products_screen.dart';
import '../categories/domain/models/category.dart';

final List<GoRoute> productsRoutes = [
  GoRoute(
    path: '/products',
    builder: (context, state) {
      final category = state.extra as Category;
      return ProductsScreen(category: category);
    },
  ),
];
