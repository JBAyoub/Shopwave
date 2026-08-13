import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/models/product.dart';
import 'package:showave/router.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onAddToCard;
  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final router = ref.read(routerProvider);
        router.go("/product/${product.id}");
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        clipBehavior: .antiAlias,
        elevation: 2,
        child: Column(
          crossAxisAlignment: .start,
          spacing: 5,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: CachedNetworkImage(
                filterQuality: .high,

                imageUrl: product.imageURL,
                fit: BoxFit.fitWidth,

                placeholder: (context, url) {
                  return const Center(child: Icon(Icons.image));
                },

                errorWidget: (context, url, error) {
                  return const Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 40),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                product.catergory,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ElevatedButton(
                onPressed: onAddToCard,
                child: Text(
                  "Add to cart",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
