import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/constant.dart';

class NotesLogic {
  static final NotesLogic _singleton = NotesLogic.instances();

  factory NotesLogic() {
    return _singleton;
  }

  NotesLogic.instances();

  Future<void> deleteNotes(
      {required String docId, required BuildContext context}) async {
    CollectionReference notes = FirebaseFirestore.instance.collection(kNotes);

    return notes
        .doc(docId)
        .delete()
        .then((value) => showCustomSnackBar(
        context: context, content: 'Success Delete Notes'))
        .catchError((error) => showCustomSnackBar(
        context: context,
        content: 'Error Delete Notes : $error',
        isError: true));
  }

}
