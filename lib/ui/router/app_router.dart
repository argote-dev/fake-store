import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/home/home_router.dart';
import '../../components/products/products_router.dart';
import '../../components/shopping_cart/shopping_cart_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ...homeRoutes,
    ...productsRoutes,
    ...shoppingCartRoutes,
  ],
);

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ...homeRoutes,
      ...productsRoutes,
      ...shoppingCartRoutes,
    ],
  );
});
