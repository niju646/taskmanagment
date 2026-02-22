import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double? size;
  const CommonText({super.key, required this.text, this.size});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontSize: size,
        ),
      ),
    );
  }
}
