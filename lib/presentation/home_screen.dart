import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_exam/business_logic/auth_business_logic.dart';
import 'package:map_exam/business_logic/note_business_logic.dart';
import 'package:map_exam/core/constant.dart';
import 'package:map_exam/presentation/edit_screen.dart';

import '../data/model/note.dart';

class HomeScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen());

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> notesStream = FirebaseFirestore.instance
      .collection(kNotes)
      .where(kUid, isEqualTo: AuthLogic().getUid)
      .snapshots();

  int notesLength = 0;

  bool isNotExpanded = false;

  int idSelected = 0;

  final notesLogic = NotesLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child: Text(
              notesLength.toString(),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: notesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  notesLength = snapshot.data?.docs.length ?? 0;
                });
              });

              return ListView.separated(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  separatorBuilder: (context, index) => const Divider(
                        color: Colors.blueGrey,
                      ),
                  itemBuilder: (context, index) {
                    var item = snapshot.data?.docs.elementAt(index);
                    var note = noteFromJson(jsonEncode(item?.data()));

                    return ListTile(
                      trailing: SizedBox(
                        width: 110.0,
                        child: idSelected == note.id
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, EditScreen.routeName,
                                          arguments: EditScreenArguments(
                                              mode: ViewMode.EDIT, note: note));
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      await notesLogic.deleteNotes(
                                          docId: item?.id ?? '',
                                          context: context);
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                      title: Text(note.title ?? ''),
                      subtitle:
                          !isNotExpanded ? Text(note.content ?? '') : null,
                      onTap: () {
                        Navigator.pushNamed(context, EditScreen.routeName,
                            arguments: EditScreenArguments(
                                mode: ViewMode.VIEW, note: note));
                      },
                      onLongPress: () {
                        setState(() {
                          if (idSelected == note.id) {
                            idSelected = 0;
                          } else {
                            idSelected = note.id;
                          }
                        });
                      },
                    );
                  });
            }
            return const Text('Something went wrong');
          }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: 'expand_content',
              child: Icon(isNotExpanded ? Icons.menu : Icons.unfold_less),
              tooltip: 'Show less. Hide notes content',
              onPressed: () {
                setState(() {
                  isNotExpanded = !isNotExpanded;
                });
              }),

          /* Notes: for the "Show More" icon use: Icons.menu */

          FloatingActionButton(
            heroTag: 'add_note',
            child: const Icon(Icons.add),
            tooltip: 'Add a new note',
            onPressed: () {
              Navigator.pushNamed(context, EditScreen.routeName,
                  arguments:
                  EditScreenArguments(mode: ViewMode.ADD));
            },
          ),
        ],
      ),
    );
  }
}
