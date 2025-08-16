import 'package:arfoon_note/client/models/note.dart';
import 'package:arfoon_note/frontend/widgets/widget.dart';
import 'package:arfoon_note/integration/blocs/note_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note data;

  const NoteCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Color? bgColor, textColor;

    return Stack(
      children: [
        InkWell(
          onLongPress: () async {
            final confirm = await showDialog(
                context: context,
                builder: (context) {
                  return  NoteDialog(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    title: 'Delete!',
                    details: 'Are you sure you want to delete it?',
                    children: [
                    dialogButtons(
                      mainAxisAlignment: MainAxisAlignment.end,
                      width: 20,
                      textButtonElevation: 1,
                      textButtonText: 'stop',
                      elevatedButtonText: 'do it.',
                      isTextButton: true,
                      elevatedButtonOnpressed: (){
                        Navigator.pop(context, true);
                      },
                      textButtonOnpressed: (){
                        Navigator.pop(context, false);
                      },
                    )
                  ]);
                });

            if (confirm == true) {
              context.read<NotesBloc>().add(DeleteNote(data.id!));
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
                  DateFormat('dd MMM').format(data.createdAt),
                ),
                const SizedBox(height: 8),
                Text(data.title ?? '',
                    style: TextStyle(color: textColor, fontSize: 24)),
                const SizedBox(height: 6),
                Text(
                  data.details ?? '',
                  style: const TextStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 6,
                  children: data.labelIds
                      .map((tag) => Chip(
                          backgroundColor:
                              const Color.fromARGB(255, 253, 253, 254),
                          side: const BorderSide(color: Color(0xFFE4E4E7)),
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 3),
                          label: Text(
                            tag.toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0XFFA2A2A2),
                                fontWeight: FontWeight.w500),
                          )))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //     top: 16,
        //     right: 20,
        //     child: Card(
        //       elevation: 0.1,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       color: data.isPinned ? Colors.black : Colors.white,
        //       child: Padding(
        //         padding: const EdgeInsets.all(13),
        //         child: Image.asset(
        //           data.isPinned
        //               ? 'assets/images/card_pin_tag.png'
        //               : 'assets/images/card_pin.png',
        //           width: 14,
        //           height: 14,
        //         ),
        //       ),
        //     )),
      ],
    );
  }
}
