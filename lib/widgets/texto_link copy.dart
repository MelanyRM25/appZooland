import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextoLink extends StatelessWidget {
  final String textoPrincipal;
  final String textoLink;
  final VoidCallback onTap;

  const TextoLink({
    super.key,
    required this.textoPrincipal,
    required this.textoLink,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: textoPrincipal,
        style: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0),
          fontSize: 13.5,
        ),
        children: [
          TextSpan(
            text: textoLink,
            style: const TextStyle(
              color: Color.fromARGB(255, 18, 173, 162),

              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
