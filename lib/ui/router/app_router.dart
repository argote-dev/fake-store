import 'package:go_router/go_router.dart';
import '../../components/home/home_router.dart';
import '../../components/products/products_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ...homeRoutes,
    ...productsRoutes,
  ],
);
