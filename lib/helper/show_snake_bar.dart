  import 'package:flutter/material.dart';

void showSnakeBar(BuildContext context, String message,
      {Color color = Colors.black54}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }