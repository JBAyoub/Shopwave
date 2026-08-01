import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/core/dio_client.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = ref.watch(dioProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Shopwave App"), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            Text(
              dio.options.baseUrl,
              style: TextStyle(fontWeight: .bold, color: Colors.grey[360]),
            ),
            Text("It  works yo!"),
          ],
        ),
      ),
    );
  }
}
