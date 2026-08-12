import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/features/product/product_provider.dart';

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
            iconSize: 25,
            onPressed: () {},
            icon: const Icon(Icons.person_outline_sharp),
          ),
          IconButton(
            iconSize: 25,
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Padding(
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
                return Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 5,
                    children: [
                      SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Image.network(
                          data[index].imageURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          data[index].catergory,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          data[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '\$${data[index].price}',
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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    );
  }
}
