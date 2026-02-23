import 'package:flutter/material.dart';
import 'package:interview/core/utils/responsive.dart';

Widget emptyScreen({double heightMultiplier = 32, required String message}) {
  return Center(
    child: Column(
      children: [
        SizedBox(height: Responsive.height * heightMultiplier),
        Icon(Icons.notes, size: 36, color: Colors.grey.shade400),
        SizedBox(height: 8),
        Text(
          message,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
