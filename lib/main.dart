import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ShopwaveApp());
}

class ShopwaveApp extends StatelessWidget {
  const ShopwaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Shopwave",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(body: Center(child: Text("NEGGERS"))),
      ),
    );
  }
}
