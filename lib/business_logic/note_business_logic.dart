import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/business_logic/auth_business_logic.dart';
import 'package:map_exam/data/model/note.dart';

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

  Future<void> addNotes(
      {required String title,
      required String content,
      required BuildContext context}) async {
    CollectionReference notesCollection =
        FirebaseFirestore.instance.collection(kNotes);

    QuerySnapshot querySnapshot = await notesCollection.get();

    Note newNote = Note(
        id: (querySnapshot.docs.length + 1),
        title: title,
        content: content,
        uid: AuthLogic().getUid);

    return notesCollection
        .add(noteToMap(newNote))
        .then((value) =>
            showCustomSnackBar(context: context, content: 'Success Add Notes'))
        .catchError((error) => showCustomSnackBar(
            context: context,
            content: 'Error Add Notes : $error',
            isError: true));
  }

  Future<String> getDocId({required int id}) async {
    final CollectionReference noteCollection =
        FirebaseFirestore.instance.collection(kNotes);

    QuerySnapshot querySnapshot = await noteCollection.get();

    final noteById =
        querySnapshot.docs.firstWhere((element) => element[kId] == id);

    return noteById.id;
  }

  Future<void> updateNotes(
      {required Note note, required BuildContext context}) async {
    CollectionReference notes = FirebaseFirestore.instance.collection(kNotes);

    return notes
        .doc(await getDocId(id: note.id))
        .update(noteToMap(note))
        .then((value) => showCustomSnackBar(
            context: context, content: 'Success Update Notes'))
        .catchError((error) => showCustomSnackBar(
            context: context,
            content: 'Error Update Notes : $error',
            isError: true));
  }
}
