// controllers/note_controller.dart
import '../database/note_database.dart';
import '../models/note_model.dart';

class NoteController {
  Future<int> addNote(Note note) async {
    return await NoteDatabase.instance.create(note);
  }

  Future<List<Note>> getAllNotes() async {
    return await NoteDatabase.instance.readAll();
  }

  Future<Note> getNoteById(int id) async {
    return await NoteDatabase.instance.read(id);
  }

  Future<int> updateNote(Note note) async {
    return await NoteDatabase.instance.update(note);
  }

  Future<int> deleteNoteById(int id) async {
    return await NoteDatabase.instance.delete(id);
  }
}
