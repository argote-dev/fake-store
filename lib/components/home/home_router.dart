import 'package:go_router/go_router.dart';
import 'presentation/home_presentation.dart';

final List<GoRoute> homeRoutes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
];
