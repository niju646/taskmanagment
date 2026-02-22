import 'package:go_router/go_router.dart';
import 'package:interview/core/routes/module/common_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [...commonRoutes],
);
