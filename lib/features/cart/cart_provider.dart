import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/models/cart_item.dart';
import 'package:showave/models/product.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return <CartItem>[];
  }

  void addItem(Product product) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
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

final cartCounterProvider = Provider<int>((ref) {
  return ref.watch(
    cartProvider.select(
      (items) => items.fold(0, (sum, item) => sum + item.quantity),
    ),
  );
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(
    cartProvider.select(
      (items) => items.fold(0, (sum, item) => sum + item.product.price),
    ),
  );
});
