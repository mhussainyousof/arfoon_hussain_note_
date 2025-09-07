import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/features/add_edit_note/add_edit_note_view.dart';
import 'package:arfoon_note/frontend/theme/note_colors.dart';
import 'package:arfoon_note/frontend/widgets/widget.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Future<List<Label>> Function(Filter?) getLabels;
  final List<Label> allLabels; // All available labels for filtering
  final AwaitCubit<List<Label>> labelsCubit;
  final AwaitCubit<List<Note>> notesCubit;
  const NoteCard(
      {super.key,
      required this.note,
      required this.getLabels,
      required this.allLabels,
      required this.notesCubit,
      required this.labelsCubit});

  @override
  Widget build(BuildContext context) {
    
    Color? noteColor =
        note.colorId != null ?
        
         AppColors.noteColors[note.colorId!] : null;
    Color textColor = noteColor != null ? Colors.white : Colors.black;
    Color dateColor = noteColor != null ? Colors.white : Colors.grey;
    Color isPinnedBGColor = note.isPinned ? Colors.black : Colors.white;

    return Stack(
      children: [
        InkWell(
          onTap: () async {
            // Navigate to edit view when card is tapped
            final updateNote = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddEditNoteView(
                        onSave: (note) async {
                          await api.notes.updateNote(note);
                          return note;
                        },
                        getLabels: getLabels,
                        note: note, // Pass current note for editing
                      )),
            );
            // If note was updated, refresh both notes and labels
            if (updateNote != null) {
              final notesCubit = context.read<AwaitCubit<List<Note>>>();
              notesCubit.refresh(filter: notesCubit.state.filter);
              await labelsCubit.refresh();
            }
          },

          //!
          //Delete Note
          onLongPress: () async {
            final confirm = await showDialog(
                context: context,
                builder: (context) {
                  return NoteDialog(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    title: 'Delete!',
                    details: 'Are you sure you want to delete it?',
                    children: [
                      const SizedBox(height: 20),
                      DialogButtons(
                        mainAxisAlignment: MainAxisAlignment.end,
                        width: 20,
                        secondaryButtonElevation: 1,
                        secondaryButtonText: 'Stop',
                        primaryButtonText: 'Delete it',
                        showSecondary: true,
                        primaryButtonOnPressed: () async {
                          await api.notes.deleteNote(note.id!);

                          Navigator.pop(context, true);
                        },
                        secondaryButtonOnPressed: () {
                          Navigator.pop(context, false);
                        },
                      )
                    ],
                  );
                });

            if (confirm == true) {
              context.read<AwaitCubit<List<Note>>>().refresh();
              await labelsCubit.refresh();
            }
          },

          child: Card(
            
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: noteColor ?? Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //!
                  //Note Date
                  Text(
                    note.updatedAt != null
                        ? DateFormat('dd MMM').format(note.updatedAt!)
                        : DateFormat('dd MMM').format(note.createdAt),
                    style: TextStyle(color: dateColor, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
            
                  //!
                  // Note title
                  Text(note.title ?? '',
                      style: TextStyle(
                          fontSize: 24,
                          color: textColor,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
            
                  //!
                  // Note Details
                  Text(
                    note.details ?? '',
                    style: TextStyle(color: dateColor),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 40),
            
                  //!
                  // Row of Labels
                  Wrap(
                    spacing: 6,
                    runSpacing: 3,
                    children: allLabels
                        .where((label) => note.labelIds.contains(label.id))
                        .map((label) => NoteChip(
                          borderRadius: BorderRadius.circular(8),
                          text: label.name,
                        labelStyle:  TextStyle(color: Colors.grey[900]!),
                           )
                            )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),

        //!

        // pin Part
        Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => _togglePinStatus(context),
              child: Container(
                width: 31,
                height: 31,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(blurRadius: 3, color: Colors.black26)
                    ],
                    color: isPinnedBGColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    note.isPinned
                        ? 'assets/images/card_pin_tag.png' // Pinned icon
                        : 'assets/images/card_pin.png', // Unpinned icon
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Future<void> _togglePinStatus(BuildContext context) async {
    try {
      // Toggle the pin status
      final updatedNote = note.copyWith(
        isPinned: !note.isPinned,
      );

      // Update the note in the database
      await api.notes.updateNote(updatedNote);

      // Refresh the notes list to show the new order
      notesCubit.refresh(filter: notesCubit.state.filter);

      // Show feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              updatedNote.isPinned ? 'Note pinned to top' : 'Note unpinned'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update pin status'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
