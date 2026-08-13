import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/models/cart_item.dart';
import 'package:showave/models/product.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return <CartItem>[];
  }

  void addItem(Product product) {
    final CartItem cartItem = state.firstWhere(
      (element) => element.product.id == product.id,
    );
    final bool exists = state.contains(cartItem);
    state = exists
        ? state = [...state, cartItem.copyWith(cartItem.quantity + 1)]
        : [...state, CartItem(product: product)];
  }

  void removeItem(Product product) {
    state = state.where((element) => element.product.id != product.id).toList();
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeItem(product);
      return;
    }

    state = [
      for (final item in state)
        if (item.product.id == product.id) item.copyWith(quantity) else item,
    ];
  }

  void clear() => const [];
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);
