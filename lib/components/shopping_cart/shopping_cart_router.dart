import 'package:go_router/go_router.dart';
import 'presentation/shopping_cart_presentation.dart';

final List<GoRoute> shoppingCartRoutes = [
  GoRoute(
    path: '/cart',
    builder: (context, state) => const ShoppingCartScreen(),
  ),
];
