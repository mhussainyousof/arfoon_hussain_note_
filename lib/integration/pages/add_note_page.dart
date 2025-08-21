import 'package:arfoon_note/client/models/note.dart';
import 'package:arfoon_note/frontend/features/add_note/add_note_view.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';

class AddNotePage extends StatelessWidget {
  final Note? note;

  const AddNotePage({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    return AddNoteView(
      note: note,
      onSave: (newNote) async {
        final saved = await api.notes.insert(newNote!);
        Navigator.pop(context, saved);
        return saved;
      },
    );
  }
}