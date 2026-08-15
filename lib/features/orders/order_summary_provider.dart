import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/features/auth/auth_provider.dart';
import 'package:showave/features/auth/auth_state.dart';
import 'package:showave/features/cart/cart_provider.dart';
import 'package:showave/models/cart_item.dart';

class OrderSummary {
  final String userName;
  final String userEmail;
  final List<CartItem> items;
  final double total;
  final int itemCount;

  OrderSummary({
    required this.userName,
    required this.userEmail,
    required this.items,
    required this.total,
    required this.itemCount,
  });

  bool get isReady => items.isNotEmpty;
}

final orderSummaryProvider = Provider<OrderSummary>((ref) {
  final authState = ref.watch(authProvider);
  final cartState = ref.watch(cartProvider);
  final cartTotalState = ref.watch(cartTotalProvider);
  final cartItemCount = ref.watch(cartCounterProvider);
  final user = authState is AuthStateAuthenticated ? authState.user : null;
  return OrderSummary(
    userName: user?.name ?? "Guest",
    userEmail: user?.email ?? "No Email provided",
    items: cartState,
    total: cartTotalState,
    itemCount: cartItemCount,
  );
});

final isCheckoutReadyProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  final cartItemCount = ref.watch(cartCounterProvider);
  return authState is AuthStateAuthenticated && cartItemCount > 0;
});
