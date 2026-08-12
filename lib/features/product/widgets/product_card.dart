import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:showave/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
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
              '\$${product.price}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              onPressed: () {},
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
    );
  }
}
