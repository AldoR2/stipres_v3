import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.buttonStyle,
      // required this.textStyle
      });
  final String label;
  final Function() onPressed;
  final ButtonStyle buttonStyle;
  // final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(
        label
      ),
    );
  }
}

class ReusableText extends StatelessWidget {
  const ReusableText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
