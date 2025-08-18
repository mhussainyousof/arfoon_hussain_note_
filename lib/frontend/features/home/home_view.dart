import 'package:arfoon_note/client/models/note.dart';
import 'package:arfoon_note/integration/blocs/label/label_bloc.dart';
import 'package:arfoon_note/integration/blocs/label/label_state.dart';
import 'package:arfoon_note/integration/blocs/note/note_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/theme.dart';
import '../../widgets/widget.dart';
import '../features.dart';
import 'widgets/home_widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BlocBuilder<LabelsBloc, LabelsState>(
        builder: (context, state) {
          if (state is LabelsError) {
            return Text("message: ${state.message}");
          }
          if (state is LabelsLoaded) {
            return  const CustomDrawer(
              userName: 'Abdurahman Popal',
              userGreeting: 'Good Morning',
            );
          }
          return const CircularProgressIndicator();
        },
      ),
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Icon(Icons.menu),
          ),
        ),
        title: 'Arfoon Note',
        textNaighbor: SvgPicture.asset(
          'assets/images/note_logo.svg',
          width: 24,
          height: 24,
        ),
      ),
      body: Column(
        children: [
          SearchNotesBar(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            hintText: 'Search Notes',
          ),
          const CategoryFilterChips(
            categories: [],
            selectedIndex: 0,
          ),
          Expanded(
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state is NotesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is NotesError) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (state is NotesLoaded) {
                  final allNotes = state.notes;

                  final filteredNotes = searchQuery.isEmpty
                      ? allNotes
                      : allNotes.where((note) {
                          final title = note.title?.toLowerCase() ?? '';
                          final details = note.details?.toLowerCase() ?? '';
                          final query = searchQuery.toLowerCase();
                          return title.contains(query) ||
                              details.contains(query);
                        }).toList();

                  if (filteredNotes.isEmpty) {
                    return const Center(child: Text('No notes found'));
                  }

                  if (state.notes.isEmpty) {
                    return const Center(child: Text('No notes found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NoteCard(note: note),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AddNoteButton(
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            final notesBloc = context.read<NotesBloc>();
            final result = await Navigator.push<Note>(
              context,
              MaterialPageRoute(builder: (context) => const AddNoteView()),
            );

            if (result != null &&
                ((result.title ?? '').isNotEmpty ||
                    (result.details ?? '').isNotEmpty)) {
              notesBloc.add(AddNoteEvent(result));
            }
          }),
    );
  }
}
