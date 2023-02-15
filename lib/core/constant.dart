import 'package:flutter/material.dart';

const Color kSuccessColor = Colors.green;
const Color kErrorColor = Colors.red;

void showCustomSnackBar(
    {required BuildContext context, required String content, bool? isError}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: (isError ?? false) ? kErrorColor : kSuccessColor,
    ),
  );
}