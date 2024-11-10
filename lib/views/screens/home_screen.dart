import 'package:flutter/material.dart';
import '../../controllers/note_controller.dart';
import '../../models/note_model.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';
import '../widgets/note_bar.dart';
import '../widgets/delete_summary_dialog.dart';
import '../widgets/search_bar.dart';  // Import your search bar

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteController _controller = NoteController();
  List<Note> notes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await _controller.getAllNotes();
    setState(() {
      notes = data;
    });
  }

  void _deleteNoteConfirm(int noteId) {
    showDialog(
      context: context,
      builder: (context) => DeleteSummaryDialog(
        onConfirm: () async {
          await _controller.deleteNoteById(noteId);
          Navigator.pop(context);
          _loadNotes();
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  // Implement the search functionality
  void _searchNotes() {
    final query = _searchController.text.toLowerCase();
    final filteredNotes = notes.where((note) {
      final titleLower = note.title.toLowerCase();
      return titleLower.contains(query);
    }).toList();

    setState(() {
      notes = filteredNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [

          Column(
            children: [
              // App bar space
              SizedBox(height: 16),  // Adjust the height as needed

              // Search Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,  // Center the row horizontally
                children: [
                  SizedBox(  // Limit the width of the row
                    width: 250,  // Adjust the width as needed
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search notes...',
                              hintStyle: TextStyle(color: Colors.grey),  // Style the hint text color
                              prefixIcon: Icon(Icons.search, color: Colors.blue),  // Icon color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),  // Rounded corners
                                borderSide: BorderSide(color: Colors.blue),  // Border color
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.blue),  // Icon color
                          onPressed: _searchNotes,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteBar(
                  note: note,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditNoteScreen(note: note)),
                    );
                    if (result == true) {
                      _loadNotes();
                    }
                  },
                  onDelete: () => _deleteNoteConfirm(note.id!),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
          _loadNotes();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.grey),
      ),
    );
  }
}
