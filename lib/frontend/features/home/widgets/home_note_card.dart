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
  final List<Label> allLabels;
  final AwaitCubit<List<Label>> labelsCubit;
  const NoteCard(
      {super.key,
      required this.note,
      required this.getLabels,
      required this.allLabels,
      required this.labelsCubit});

  @override
  Widget build(BuildContext context) {

     Color? noteColor = note.colorId != null 
        ? AppColors.noteColors[note.colorId!] 
        : null;

         Color textColor = noteColor != null ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color!;


    return Stack(
      children: [
        InkWell(
          onTap: () async {
            final updateNote = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddEditNoteView(
                        onSave: (note) async {
                          await api.notes.updateNote(note);
                          return note;
                        },
                        getLabels: getLabels,
                        note: note,
                      )),
            );
            if (updateNote != null) {
              final notesCubit = context.read<AwaitCubit<List<Note>>>();

              notesCubit.refresh(filter: notesCubit.state.filter);
              await labelsCubit.refresh();
            }
          },
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
              //  border: noteColor != null 
              //     ? Border.all(color: noteColor.withOpacity(0.3), width: 1)
              //     : null,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.updatedAt != null
                      ? DateFormat('dd MMM').format(note.updatedAt!)
                      : DateFormat('dd MMM').format(note.createdAt),
                      style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 8),
                Text(note.title ?? '',
                    style:  TextStyle( fontSize: 24, color: textColor)),
                const SizedBox(height: 6),
                Text(
                  note.details ?? '',
                  style:  TextStyle(
                    color: textColor
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 6,
                  runSpacing: 3,
                  children: allLabels
                      .where((label) => note.labelIds
                          .contains(label.id)) 
                      .map((label) => Chip(
                            label: Text(label.name),
                            backgroundColor: Colors.grey.shade200,
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
