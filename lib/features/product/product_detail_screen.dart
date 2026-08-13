import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showave/features/product/product_details_provider.dart';
import 'package:showave/features/product/product_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(productId));
    final cachedProduct = ref
        .watch(productsProvider)
        .value
        ?.firstWhere((p) => p.id == product.value?.id);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        titleSpacing: 10,
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          cachedProduct?.name ?? product.value?.name ?? "Product Details",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: product.when(
            data: (data) {
              return Card(
                elevation: 5,
                clipBehavior: .antiAlias,
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(16),
                ),
                shadowColor: Theme.of(context).colorScheme.primary,
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 10,
                  children: [
                    AspectRatio(
                      aspectRatio: 12 / 9,
                      child: CachedNetworkImage(
                        imageUrl: data.imageURL,
                        filterQuality: .high,
                        fit: .cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        data.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Text(
                          data.catergory,
                          style: Theme.of(context).textTheme.headlineSmall!,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        data.description,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(color: Color.fromARGB(148, 6, 6, 6)),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        softWrap: true,
                        "\$${data.price.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              shadows: List.generate(2, (index) {
                                return Shadow(
                                  blurRadius: 1,
                                  color: const Color.fromARGB(100, 0, 0, 0),
                                  offset: Offset(1, 2),
                                );
                              }),

                              fontWeight: .bold,
                              color: Color.fromARGB(197, 255, 191, 54),
                            ),
                      ),
                    ),
                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      child: SizedBox(
                        width: .infinity,
                        height: 80,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${data.name} Added to Cart!"),
                              ),
                            );
                          },
                          child: Text(
                            "Add to Cart",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
