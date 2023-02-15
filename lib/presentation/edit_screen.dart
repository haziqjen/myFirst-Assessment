import 'package:flutter/material.dart';
import 'package:map_exam/business_logic/auth_business_logic.dart';
import 'package:map_exam/business_logic/note_business_logic.dart';
import 'package:map_exam/core/constant.dart';
import 'package:map_exam/data/model/note.dart';

class EditScreenArguments {
  final ViewMode mode;
  final Note? note;

  EditScreenArguments({required this.mode, this.note});
}

class EditScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const EditScreen());
  static const routeName = '/editScreen';

  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final notesLogic = NotesLogic();

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)!.settings.arguments as EditScreenArguments;

    _titleController.text = argument.note?.title ?? '';
    _descriptionController.text = argument.note?.content ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text('${getTitleAppBar(argument.mode)} Notes'),
        actions: [
          argument.mode == ViewMode.VIEW
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(
                    Icons.check_circle,
                    size: 30,
                  ),
                  onPressed: () async {
                    if (argument.mode == ViewMode.EDIT) {
                      await notesLogic.updateNotes(
                          note: Note(
                              id: argument.note?.id ?? 0,
                              title: _titleController.text,
                              content: _descriptionController.text,
                              uid: AuthLogic().getUid),
                          context: context);
                    } else if (argument.mode == ViewMode.ADD) {
                      await notesLogic.addNotes(
                          title: _titleController.text,
                          content: _descriptionController.text,
                          context: context);
                    }

                    Navigator.pop(context);
                  }),
          IconButton(
              icon: const Icon(
                Icons.cancel_sharp,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              initialValue: null,
              enabled: argument.mode != ViewMode.VIEW,
              decoration: const InputDecoration(
                hintText: 'Type the title here',
              ),
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: TextFormField(
                  controller: _descriptionController,
                  enabled: argument.mode != ViewMode.VIEW,
                  initialValue: null,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Type the description',
                  ),
                  onChanged: (value) {}),
            ),
          ],
        ),
      ),
    );
  }
}
