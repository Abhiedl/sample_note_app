import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:note_app/data/data.dart';
import 'package:note_app/data/note_model/note_model.dart';

enum ActionType {
  addNote,
  editNote,
}

class AddNoteScreen extends StatelessWidget {
  final List<NoteModel> noteLists = [];
  final ActionType type;
  String? id;
  AddNoteScreen({
    super.key,
    required this.type,
    this.id,
  });
  Widget get saveButton => TextButton.icon(
        onPressed: () {
          switch (type) {
            case ActionType.addNote:
              saveNote();
              break;
            case ActionType.editNote:
              saveEditedNote();
              break;
          }
        },
        icon: const Icon(
          Icons.save,
          color: Color.fromARGB(255, 9, 174, 78),
        ),
        label: const Text(
          'Save',
          style: TextStyle(color: Color.fromARGB(255, 9, 174, 78)),
        ),
      );

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (type == ActionType.editNote) {
      if (id == null) {
        Navigator.of(context).pop();
      }
      final note = NoteDB.instance.getNoteById(id!);
      if (note == null) {
        Navigator.of(context).pop();
      }
      titleController.text = note!.title ?? 'No title';
      contentController.text = note.content ?? 'No content';
    }
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text(type.name.toUpperCase()),
        actions: [
          saveButton,
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Title'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: contentController,
              maxLines: 4,
              maxLength: 100,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Content'),
            )
          ],
        ),
      )),
    );
  }

  Future<void> saveNote() async {
    final title = titleController.text;
    final content = contentController.text;

    final newNote = NoteModel.create(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
    );
    final new_Note = await NoteDB.instance.createNote(newNote);
    if (new_Note != null) {
      print('Note saved.');
      Navigator.of(scaffoldkey.currentContext!).pop();
    } else {
      print('Error while saving note.');
    }
    NoteDB.instance.getAllNotes();
  }

  Future<void> saveEditedNote() async {
    final title = titleController.text;
    final content = contentController.text;
    final editedNote = NoteModel.create(
      id: id,
      title: title,
      content: content,
    );
    NoteDB.instance.updateNote(editedNote);
    Navigator.of(scaffoldkey.currentContext!).pop();
  }
}
