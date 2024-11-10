// views/add_note_screen.dart
import 'package:flutter/material.dart';
import '../../controllers/note_controller.dart';
import '../../controllers/note_controller.dart';
import '../../models/note_model.dart';

class AddNoteScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final NoteController _controller = NoteController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            ElevatedButton(
              onPressed: () async {
                final note = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                );
                await _controller.addNote(note);
                Navigator.pop(context);
              },
              child: const Text("Save Note"),
            ),
          ],
        ),
      ),
    );
  }
}
