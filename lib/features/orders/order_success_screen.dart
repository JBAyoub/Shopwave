import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessScreen extends ConsumerWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,
        title: Text(
          "Order confirmed",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: .bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            spacing: 10,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: const Color.fromARGB(159, 84, 190, 87),
                size: 100,
              ),
              const Text(
                "Order Placed!",
                style: TextStyle(fontSize: 30, fontWeight: .bold),
              ),
              Text(
                "Order #$orderId",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color.fromARGB(100, 0, 0, 0),
                  fontWeight: .bold,
                ),
              ),

              Card(
                elevation: 2,
                borderOnForeground: true,
                color: const Color(0xFFE4F3E4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
                clipBehavior: .antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    textBaseline: .alphabetic,
                    crossAxisAlignment: .center,
                    mainAxisAlignment: .start,
                    spacing: 10,
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF5C9477),
                      ),
                      Expanded(
                        child: const Text(
                          overflow: .clip,
                          "We'll email you when your order ships.",
                          style: TextStyle(
                            fontWeight: .bold,
                            color: Color(0xFF5C9477),
                            wordSpacing: 2,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: .maxFinite,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "View Order History",
                    style: TextStyle(fontWeight: .bold),
                  ),
                ),
              ),
              SizedBox(
                width: .maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    context.go("/products");
                  },
                  child: Text(
                    "Continue Shopping",
                    style: TextStyle(fontWeight: .bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
