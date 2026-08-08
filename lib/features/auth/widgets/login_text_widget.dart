import 'package:flutter/material.dart';

class LoginFieldWidget extends StatelessWidget {
  LoginFieldWidget({
    super.key,
    required this.placeHolderText,
    required this.hidden,
    required this.icon,
  });
  final String placeHolderText;
  final bool hidden;
  final Icon icon;
  final defaultBorder = OutlineInputBorder(
    borderSide: BorderSide(
      width: 0,
      strokeAlign: BorderSide.strokeAlignOutside,
      color: const Color.fromARGB(255, 193, 188, 162),
    ),
    borderRadius: BorderRadius.all(Radius.circular(15)),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: hidden,
      enableInteractiveSelection: true,
      keyboardType: .emailAddress,
      autofocus: true,
      enableIMEPersonalizedLearning: true,
      autocorrect: false,
      decoration: InputDecoration(
        hint: Text(
          placeHolderText,
          style: TextStyle(
            fontWeight: .w700,
            letterSpacing: 2,
            overflow: .fade,
            color: Color.fromARGB(200, 114, 114, 114),
          ),
        ),
        fillColor: const Color.fromARGB(255, 241, 241, 240),
        suffixIcon: icon,
        suffixIconColor: const Color.fromARGB(100, 22, 22, 22),
        filled: true,
        enabledBorder: defaultBorder,
        focusedBorder: defaultBorder,
      ),
    );
  }
}
