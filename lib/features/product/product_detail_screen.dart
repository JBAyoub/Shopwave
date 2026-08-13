import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/features/product/product_details_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(productId));
    return Scaffold(
      body: Center(
        child: product.when(
          data: (data) {
            return Column(
              children: [
                Text(data.id),
                Text(data.description),
                Text(data.name),
              ],
            );
          },
          error: (error, stackTrace) => SafeArea(
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.diversity_2_outlined, size: 50),
                  Text("Something Wrong Happened here"),
                  Text(error.toString()),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(productProvider(productId));
                    },
                    child: Text("refresh data"),
                  ),
                ],
              ),
            ),
          ),
          loading: () => CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
