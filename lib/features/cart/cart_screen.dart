import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/features/cart/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: cartState.length,
          itemBuilder: (context, index) {
            return Text(cartState[index].product.name);
          },
        ),
      ),
    );
  }
}
