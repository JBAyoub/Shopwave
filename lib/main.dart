import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showave/features/auth/login_screen.dart';

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
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
          useMaterial3: true,
          textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
