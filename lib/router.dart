import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showave/features/auth/auth_provider.dart';
import 'package:showave/features/auth/auth_state.dart';
import 'package:showave/features/auth/login_screen.dart';
import 'package:showave/features/cart/cart_screen.dart';
import 'package:showave/features/orders/checkout_screen.dart';
import 'package:showave/features/orders/order_history_screen.dart';
import 'package:showave/features/orders/order_success_screen.dart';
import 'package:showave/features/product/product_detail_screen.dart';
import 'package:showave/features/product/products_screen.dart';
import 'package:showave/features/profile/profile_screen.dart';

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthChangeNotifier(ref);
  final publicRoutes = ['/login'];
  return GoRouter(
    initialLocation: "/products",
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isPublicRoute = publicRoutes.contains(state.matchedLocation);
      final authState = ref.read(authProvider);
      if (authState is! AuthStateAuthenticated) {
        return isPublicRoute ? null : "/login";
      }
      if (isPublicRoute) return "/products";
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) =>
            ProductDetailScreen(productId: state.pathParameters["id"] ?? ""),
      ),
      GoRoute(
        path: '/order-success/:id',
        builder: (context, state) =>
            OrderSuccessScreen(orderId: state.pathParameters["id"] ?? ""),
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order_history',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
