import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showave/features/auth/auth_provider.dart';
import 'package:showave/features/auth/auth_state.dart';
import 'package:showave/features/auth/login_screen.dart';

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
    initialLocation: "/login",
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
    ],
  );
});
