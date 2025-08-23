import 'package:arfoon_note/frontend/features/home/widgets/home_note_card.dart';
import 'package:arfoon_note/integration/blocs/note/note_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllNotesView extends StatelessWidget {
  const AllNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Notes"),
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotesError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is NotesLoaded) {
            final notes = state.notes;

            if (notes.isEmpty) {
              return const Center(child: Text("No notes found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NoteCard(note: note
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
