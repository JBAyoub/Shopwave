import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showave/features/cart/cart_provider.dart';
import 'package:showave/features/product/product_provider.dart';
import 'package:showave/features/product/widgets/product_card.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});
  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 20),
        title: const Text("ShopWave", style: TextStyle(fontSize: 28)),
        titleSpacing: 20,
        elevation: 0,
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            iconSize: 20,
            onPressed: () {
              context.push("/profile");
            },
            icon: const Icon(Icons.person_outline_sharp),
          ),
          Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(cartCounterProvider);
              return Stack(
                children: [
                  IconButton(
                    iconSize: 20,
                    onPressed: () {
                      context.push("/cart");
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: Text(
                          "$count",
                          softWrap: true,
                          textAlign: .justify,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(productsProvider.notifier).referesh();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: productsState.when(
            data: (data) {
              return GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: data[index],
                    onAddToCard: () {
                      ref.read(cartProvider.notifier).addItem(data[index]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            label: "View Cart",
                            onPressed: () => context.go("/cart"),
                          ),
                          content: Text(
                            "${data[index].name} was added to the cart!",
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },

            error: (error, stackTrace) {
              return Center(
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  children: [
                    const Icon(
                      Icons.not_interested_sharp,
                      size: 50,
                      color: Color.fromARGB(199, 235, 57, 51),
                    ),
                    Text(
                      "An Error Has Occured.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },

            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
