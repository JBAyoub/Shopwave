import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:showave/features/orders/order_provider.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History", style: TextStyle(fontSize: 25)),
        centerTitle: true,
      ),
      body: ordersAsync.when(
        data: (orders) {
          return orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .stretch,
                    children: [
                      const Icon(Icons.shopping_cart_outlined),
                      Text(
                        "Orders you place will appear here!",
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: .center,
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  "#${orders[index].id}",
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: .bold),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  orders[index].items.length > 1
                                      ? "${orders[index].items.length} items . ${DateFormat.yMMMd().format(orders[index].createdAt)}"
                                      : "1 item . ${DateFormat.yMMMd().format(orders[index].createdAt)} ",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: .center,
                              crossAxisAlignment: .end,
                              children: [
                                Chip(
                                  label: Text(orders[index].status.label),
                                  backgroundColor:
                                      orders[index].status.chipBgColor,
                                  color: WidgetStatePropertyAll(
                                    orders[index].status.chipColor,
                                  ),
                                  clipBehavior: .antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: .circular(16),
                                  ),
                                  labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 0,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "\$${orders[index].total}",
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontSize: 16,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 5),
                  itemCount: orders.length,
                );
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            children: [
              const Icon(
                Icons.error_outline_sharp,
                color: Color.fromARGB(206, 231, 58, 0),
              ),
              const Text(
                "Something went wrong!",
                style: TextStyle(fontSize: 25),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(orderProvider);
                },
                child: Text("Retry"),
              ),
            ],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
