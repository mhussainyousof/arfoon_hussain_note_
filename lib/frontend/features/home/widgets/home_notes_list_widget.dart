import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/features/home/home.dart';
import 'package:arfoon_note/integration/integration.dart';

class NotesList extends StatelessWidget {
  final Future<List<Note>> Function(Filter?) getNotes;
  final Future<List<Label>> Function(Filter?) getLabels;
  final AwaitCubit<List<Note>> notesCubit;
  final AwaitCubit<List<Label>> labelsCubit;
  final void Function(Note) selectNote;

  final bool isMobile;
  final bool isDesktop;

  const NotesList({
    super.key,
    required this.getNotes,
    required this.getLabels,
    required this.notesCubit,
    required this.labelsCubit,
    required this.selectNote,
    required this.isMobile,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AwaitBuilder<List<Note>>(
        cubit: notesCubit,
        getData: getNotes,
        builder: (context, state) {
          if (state.status == AwaitStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AwaitStatus.error) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state.data == null || state.data!.isEmpty) {
            return const Center(
              child: LocaleText('no_note'),
            );
          }
          final currentLabels = labelsCubit.state.data ?? [];
          return ListView.builder(
            padding: EdgeInsets.only(top: isMobile ? 15 : 0),
            itemCount: state.data!.length,
            itemBuilder: (context, index) {
              final note = state.data![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NoteCard(
                  note: note,
                  getLabels: getLabels,
                  allLabels: currentLabels,
                  labelsCubit: labelsCubit,
                  notesCubit: notesCubit,
                  onTap: isDesktop ? () => selectNote(note) : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
