import 'package:flutter/material.dart';
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
                  onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.cancel_sharp,
                size: 30,
              ),
              onPressed: () {}),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              initialValue: null,
              enabled: true,
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
                  enabled: true,
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
