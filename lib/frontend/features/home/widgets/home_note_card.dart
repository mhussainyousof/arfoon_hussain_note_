import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/frontend/theme/note_colors.dart';
import 'package:arfoon_note/frontend/theme/responsive.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bidi_text/bidi_text.dart';
import 'package:flutter_bidi_text/flutter_bidi_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note? note;
  final Future<List<Label>> Function(Filter?) getLabels;
  final List<Label> allLabels;
  final AwaitCubit<List<Label>> labelsCubit;
  final AwaitCubit<List<Note>> notesCubit;
  final VoidCallback? onTap;
  const NoteCard(
      {super.key,
      required this.note,
      required this.getLabels,
      required this.allLabels,
      required this.notesCubit,
      required this.labelsCubit,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    Color? noteColor = note!.colorId != null
        ? AppColors.noteColors[note!.colorId!]
        : isDark
            ? Colors.grey[900]
            : null;
    Color textColor = noteColor != null ? Colors.white : Colors.black;
    Color dateColor = Colors.white;
    Color isPinnedBGColor = note!.isPinned ? Colors.black : Colors.white;

    return Stack(
      children: [
        InkWell(
          onTap: isDesktop
              ? onTap
              : () async {
                  // Navigate to edit view when card is tapped
                  final updateNote = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddEditNoteView(
                              onSave: (note) async {
                                await api.noteServer.notes.updateNote(note);
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
                    context.read<AwaitCubit<List<Note>>>().refresh();
                  }
                },

          //!
          //Delete Note
          onLongPress: () async {
          SureView(
                title: 'delete',
                subTitle: 'confirm_delete',
                sureText: 'delete',
                onSure: () async{
                  await api.noteServer.notes.deleteNote(note!.id!);
                  await labelsCubit.refresh();
                  context.read<AwaitCubit<List<Note>>>().refresh();
                }).show(context);
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //!
                  //Note Date
                  if (note?.createdAt != null)
                    Builder(builder: (context) {
                      final date = note!.updatedAt ?? note!.createdAt;
                      final local =
                          Locales.currentLocale(context)!.languageCode;
                      String formattedDate;
                      if (local == 'fa' || local == 'ps') {
                        formattedDate = DateFormat('d MMM', 'fa').format(date);
                      } else {
                        formattedDate = DateFormat('dd MMM').format(date);
                      }
                      return Text(
                        formattedDate,
                        style: TextStyle(color: dateColor, fontSize: 12),
                      );
                    }),
                  const SizedBox(height: 8),

                  //!
                  // Note title
                  BidiText(
                      sampleLength: null,
                      note!.title ?? '',
                      style: TextStyle(
                          fontSize: 24,
                          color: textColor,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),

                  //!
                  // Note Details
                  BidiText(
                    note!.details ?? '',
                    style: TextStyle(color: textColor),
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
                        .where((label) => note!.labelIds.contains(label.id))
                        .map((label) => NoteChip(
                              borderRadius: BorderRadius.circular(8),
                              text: label.name,
                              labelStyle: TextStyle(color: Colors.grey[900]!),
                            ))
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
            right: isRTL(context) ? null : 20,
            left: isRTL(context) ? 20 : null,
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
                    note!.isPinned
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
      final updatedNote = note!.copyWith(
        isPinned: !note!.isPinned,
      );

      // Update the note in the database
      await api.noteServer.notes.updateNote(updatedNote);

      // Refresh the notes list to show the new order
      notesCubit.refresh(filter: notesCubit.state.filter);
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
