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
  const NoteCard(
      {super.key,
      required this.note,
      required this.getLabels,
      required this.allLabels,
      required this.labelsCubit});

  @override
  Widget build(BuildContext context) {


    Color? noteColor = note.colorId != null ? AppColors.noteColors[note.colorId!] : null;
    Color textColor = noteColor != null ? Colors.white : Colors.black;
    Color dateColor = noteColor != null ? Colors.white : Colors.grey;

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
                        note: note,  // Pass current note for editing
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
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: noteColor,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(25),
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
                            text: label.name,
                            labelStyle: const TextStyle(fontSize: 11),
                            backgroundColor: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
