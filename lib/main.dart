import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/features/auth/login_screen.dart';
import 'package:showave/features/home/home.dart';

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
        home: LoginScreen(),
      ),
    );
  }
}
