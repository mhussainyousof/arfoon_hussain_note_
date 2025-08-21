import 'package:arfoon_note/client/models/note.dart';
import 'package:arfoon_note/frontend/features/add_note/add_note_view.dart';
import 'package:flutter/material.dart';

class AddNoteExample extends StatelessWidget {
  const AddNoteExample({super.key});

  @override
  Widget build(BuildContext context) {

    Future<Note>fakeData(Note? note)async{
          // await Future.delayed(const Duration(seconds: 5));

          throw Exception('there is an error');

      // return Note(  id: 1,
      // title: note?.title ?? "Test Title",
      // details: note?.details ?? "Test Details",
      // createdAt: DateTime.now(),
      // updatedAt: DateTime.now(),
      // labelIds: [],);
    }


  return AddNoteView(
    note: null,
    onSave: fakeData);
  
  }
}