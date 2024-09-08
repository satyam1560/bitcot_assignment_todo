import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String regularText;
  final String clickableText;
  final VoidCallback onTap;

  const CustomRichText({
    super.key,
    required this.regularText,
    required this.clickableText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: regularText,
        style: const TextStyle(
          color: Color(0xFF000000), 
          fontSize: 16,
        ),
        children: <TextSpan>[
          TextSpan(
            text: clickableText,
            style: const TextStyle(
              color: Color(0xFFD3281C),
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
