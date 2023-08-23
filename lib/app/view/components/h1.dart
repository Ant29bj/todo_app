import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  const H1({super.key, required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
    );
  }
}
