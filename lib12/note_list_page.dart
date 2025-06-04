import 'package:flutter/material.dart';
import 'db_provider.dart';
import 'note_add_update_page.dart';
import 'package:provider/provider.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: Consumer<DbProvider>(
        builder: (_, provider, child) {
          final notes = provider.notes;
          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, index) {
              final note = notes[index];
              return Dismissible(
                key: Key(note.id?.toString() ?? UniqueKey().toString()),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  provider.deleteNote(note.id!);
                },
                child: Card(
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: Text('Hapus note "${note.title}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.deleteNote(note.id!);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    onTap: () async {
                      final selectedNote = await provider.getNoteById(note.id!);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteAddUpdatePage(note: selectedNote),
                        ),
                      );
                      await provider.refreshNotes();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteAddUpdatePage()),
          );
        },
      ),
    );
  }
}
