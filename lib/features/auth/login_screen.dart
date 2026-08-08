import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showave/features/auth/widgets/login_text_widget.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Container(
          isAntiAlias: true,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.2,
              color: const Color.fromARGB(255, 226, 226, 223),
            ),
            borderRadius: BorderRadius.circular(16),
            color: const Color.fromARGB(255, 193, 188, 162),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: SizedBox(
              width: double.maxFinite,
              height: 500,
              child: Column(
                mainAxisSize: .max,
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                spacing: 15,
                children: [
                  const Text(
                    softWrap: true,
                    "ShopWave",
                    style: TextStyle(
                      color: Color.fromARGB(255, 41, 41, 41),
                      fontSize: 36,
                      fontWeight: .bold,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LoginFieldWidget(
                    placeHolderText: "email@example.com",
                    hidden: false,
                    icon: Icon(Icons.alternate_email_sharp),
                  ),
                  LoginFieldWidget(
                    placeHolderText: "**********",
                    hidden: true,
                    icon: Icon(Icons.shield_sharp),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: .maxFinite,
                    height: 40,
                    child: FilledButton(
                      onPressed: () {},
                      child: Text("Login", style: TextStyle(fontSize: 26)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
