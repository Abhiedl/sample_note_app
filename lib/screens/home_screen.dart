import 'package:flutter/material.dart';
import 'package:note_app/data/data.dart';
import 'package:note_app/data/note_model/note_model.dart';
import 'package:note_app/screens/add_note.dart';
import 'package:note_app/screens/note_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NoteDB.instance.getAllNotes();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notes'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: NoteDB.instance.noteListNotifier,
          builder: (context, List<NoteModel> newNotes, _) {
            return GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(20),
              children: List.generate(newNotes.length, (index) {
                final note = NoteDB.instance.noteListNotifier.value[index];
                if (note.id == null) {
                  return const SizedBox();
                }
                return NoteItem(
                  id: note.id!,
                  title: note.title ?? 'No title.',
                  content: note.content ?? 'No content.',
                );
              }),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => AddNoteScreen(type: ActionType.addNote),
            ),
          );
        },
        label: const Text('New'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
