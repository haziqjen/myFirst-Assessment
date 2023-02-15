import 'package:flutter/material.dart';

const Color kSuccessColor = Colors.green;
const Color kErrorColor = Colors.red;

//Firestore Key Constant
const String kNotes = 'notes';
const String kUid = 'uid';
const String kId = 'id';
const String kTitle = 'title';
const String kContent = 'content';

//Mode View
const String kEdit = 'Edit';
const String kAdd = 'Add';
const String kView = 'View';

enum ViewMode { EDIT, ADD, VIEW }

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

String getTitleAppBar(ViewMode mode) {
  switch (mode) {
    case ViewMode.EDIT:
      return kEdit;
    case ViewMode.ADD:
      return '$kAdd new';
    case ViewMode.VIEW:
      return kView;
    default:
      return kView;
  }
}