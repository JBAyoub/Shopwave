import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/core/constants.dart';
import 'package:showave/core/dio_client.dart';
import 'package:showave/models/product.dart';

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  FutureOr<List<Product>> build() async {
    final dio = ref.watch(authenticatedDioProvider);
    final response = await dio.get(AppConstants.productsRoute);
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> referesh() async {}
}

final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);
