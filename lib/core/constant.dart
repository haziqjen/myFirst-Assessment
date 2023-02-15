import 'package:flutter/material.dart';

const Color kSuccessColor = Colors.green;
const Color kErrorColor = Colors.red;

//Firestore Key Constant
const String kNotes = 'notes';
const String kUid = 'uid';
const String kId = 'id';
const String kTitle = 'title';
const String kContent = 'content';

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