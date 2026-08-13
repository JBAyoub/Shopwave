import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/core/constants.dart';
import 'package:showave/core/dio_client.dart';
import 'package:showave/models/product.dart';

final productProvider = FutureProvider.autoDispose.family<Product, String>((
  ref,
  param,
) async {
  final dio = ref.watch(authenticatedDioProvider);
  final response = await dio.get('${AppConstants.productRoute}/$param');
  final product = Product.fromJson(response.data as Map<String, dynamic>);
  return product;
});
