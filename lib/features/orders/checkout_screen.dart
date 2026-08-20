import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:showave/features/orders/order_provider.dart';
import 'package:showave/features/orders/order_summary_provider.dart';
import 'package:showave/models/order.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderSummary = ref.watch(orderSummaryProvider);
    final orderState = ref.watch(orderProvider);
    final isLoading = orderState.isLoading;
    final isReady = ref.watch(isCheckoutReadyProvider);

    ref.listen<AsyncValue<List<Order>>>(orderProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue) {
        final orders = next.value ?? [];
        if (orders.isNotEmpty) {
          context.push('/order-success/${orders.first.id}');
        }
      }
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 244, 73, 73),
            behavior: .floating,
            content: Text("Order Failed: ${next.error}"),
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
        title: Text(
          "Checkout",
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontSize: 25, fontWeight: .w500),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 10,
            children: [
              Text(
                "Hi, ${orderSummary.userName}",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Review your order before confirming",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color.fromARGB(138, 0, 0, 0),
                  fontWeight: .w600,
                ),
              ),
              Card.filled(
                clipBehavior: .antiAlias,
                color: const Color.fromRGBO(242, 242, 242, 1),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                borderOnForeground: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        "${orderSummary.itemCount} items in your order",
                        style: TextStyle(
                          fontWeight: .bold,
                          color: const Color.fromRGBO(0, 0, 0, 0.9),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        height: 20,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        thickness: 1,
                      ),
                      ...orderSummary.items.map((e) {
                        return Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      Text(
                                        e.product.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                      ),
                                      Text(
                                        "x${e.quantity}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  "\$${e.subtotal.toStringAsFixed(2)}",
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontSize: 15,
                                        fontWeight: .w700,
                                      ),
                                ),
                              ],
                            ),

                            const Divider(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              thickness: 1,
                            ),
                          ],
                        );
                      }),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: .bold),
                          ),
                          Text(
                            "\$${orderSummary.total}",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: .bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                height: 60,
                width: double.maxFinite,
                child: isReady
                    ? ElevatedButton(
                        onPressed: () {
                          isLoading
                              ? null
                              : ref
                                    .read(orderProvider.notifier)
                                    .placeOrder(orderSummary);
                        },
                        child: Text("Place Order - \$${orderSummary.total}"),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
