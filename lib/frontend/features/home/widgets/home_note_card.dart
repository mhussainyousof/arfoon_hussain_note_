import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/features/add_edit_note/add_edit_note_view.dart';
import 'package:arfoon_note/frontend/widgets/widget.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Future<List<Label>> Function(Filter?) getLabels;

  const NoteCard({super.key, required this.note, required this.getLabels});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final labelCubit = AwaitCubit<List<Label>>();

  @override
  Widget build(BuildContext context) {
    Color? bgColor, textColor;

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
                        getLabels: widget.getLabels,
                        note: widget.note,
                      )),
            );
            if (updateNote != null) {
           final notesCubit = context.read<AwaitCubit<List<Note>>>();
           notesCubit.refresh(filter:     notesCubit.state.filter);

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
                        primaryButtonText: 'Do it',
                        showSecondary: true,
                        primaryButtonOnPressed: () async {
                          await api.notes.deleteNote(widget.note.id!);

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
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.note.updatedAt != null
                      ? DateFormat('dd MMM').format(widget.note.updatedAt!)
                      : DateFormat('dd MMM').format(widget.note.createdAt),
                ),
                const SizedBox(height: 8),
                Text(widget.note.title ?? '',
                    style: TextStyle(color: textColor, fontSize: 24)),
                const SizedBox(height: 6),
                Text(
                  widget.note.details ?? '',
                  style: const TextStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                AwaitBuilder<List<Label?>>(
                  getData: widget.getLabels,
                  cubit: labelCubit,
                  builder: (context, state) {
                    final label = state.data ?? [];
                    final selectedLabels = label.where(
                        (label) => widget.note.labelIds.contains(label?.id));
                    return Wrap(
                        spacing: 6,
                        runSpacing: 3,
                        children: selectedLabels.map((label) {
                          if (label == null) return const SizedBox();
                          return Chip(
                            label: Text(label.name),
                            backgroundColor: Colors.grey.shade200,
                          );
                        }).toList());
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
