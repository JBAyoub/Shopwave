import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showave/router.dart';

void main() {
  runApp(ProviderScope(child: const ShopwaveApp()));
}

class ShopwaveApp extends ConsumerWidget {
  const ShopwaveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      title: "Shopwave",
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
      ),
    );
  }
}
