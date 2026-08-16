import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/core/constants.dart';
import 'package:showave/core/dio_client.dart';
import 'package:showave/features/cart/cart_provider.dart';
import 'package:showave/features/orders/order_summary_provider.dart';
import 'package:showave/models/order.dart';

class OrderNotifier extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() async {
    final dio = ref.read(authenticatedDioProvider);
    final response = await dio.get(AppConstants.orderRoute);
    final List<dynamic> data = response.data as List<dynamic>;
    final List<Order> result = data
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
    return result;
  }

  Future<Order> placeOrder(OrderSummary summary) async {
    final previousOrders = state.asData?.value ?? [];
    state = const AsyncLoading();
    final payload = {
      "items": summary.items.map((e) {
        return {
          "productId": e.product.id,
          "productName": e.product.name,
          'quantity': e.quantity,
          "priceAtPurchase": e.product.price,
        };
      }).toList(),
      "total": summary.total,
    };
    late Order newOrder;
    final dio = ref.read(authenticatedDioProvider);
    state = await AsyncValue.guard(() async {
      final response = await dio.post(AppConstants.orderRoute, data: payload);
      newOrder = Order.fromJson(response.data as Map<String, dynamic>);
      ref.invalidate(cartProvider);
      return [newOrder, ...previousOrders];
    });

    if (state.hasError) throw state.error!;
    return newOrder;
  }
}

final orderProvider = AsyncNotifierProvider<OrderNotifier, List<Order>>(
  OrderNotifier.new,
);
