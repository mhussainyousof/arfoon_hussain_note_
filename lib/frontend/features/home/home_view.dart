import 'package:arfoon_note/client/models/note.dart';
import 'package:arfoon_note/frontend/features/add_note/add_note_view.dart';
import 'package:arfoon_note/frontend/features/drawer/drawer.dart';
import 'package:arfoon_note/integration/blocs/note_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/theme.dart';
import '../../widgets/widget.dart';
import 'widgets/home_widgets.dart';

class HomeView extends StatefulWidget {
  // final List<String> categories;
  // final int selectedCategoryIndex;
  // final Future<List<Note>> getNotes;
  // final Function(Note)? onNoteAdded;

  const HomeView({
    super.key,
    // required this.categories,
    // required this.selectedCategoryIndex,
    // required this.getNotes,
    // this.onNoteAdded,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note> notes = [];
  bool loading = false;
  String? error;

  // Future<void> _loadNotes() async {
  //   setState(() {
  //     loading = true;
  //     error = null;
  //   });
  //   try {
  //     notes = await widget.getNotes;
  //   } catch (e) {
  //     error = e.toString();
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadNotes();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(
        labels: ['Office', 'Home', 'Design', 'Code', 'To learn'],
        userName: 'Abdurahman Popal',
        userGreeting: 'Good Morning',
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
          const SearchNotesBar(
            hintText: 'Search Notes',
          ),
          const CategoryFilterChips(
            categories: [],
            selectedIndex: 0,
          ),
          // if (loading)
          //   const Center(child: CircularProgressIndicator())
          // else if (error != null)
          //   Center(child: Text('Error: $error'))
          // else if (notes.isEmpty)
          //   const Center(child: Text('No notes found.'))
          // else

          Expanded(
            child: BlocBuilder<NotesBloc, NotesState>(

              builder: (context, state) {
                if(state is NotesLoading){
                  return const Center(child: CircularProgressIndicator());

                }

                if(state is NotesError){
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (state is NotesLoaded){
                  if(state.notes.isEmpty){
                    return const Center(child: Text('No text found'));
                  }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.notes.length,
                  itemBuilder: (context, index) {
                    final note = state.notes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NoteCard(data: note),
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
            final result = await Navigator.push<Note>(
              context,
              MaterialPageRoute(builder: (_) => const AddNoteView()),
            );
            if (!mounted) return;

            if (result != null &&
                ((result.title ?? '').isNotEmpty ||
                    (result.details ?? '').isNotEmpty)) {
                      context.read<NotesBloc>().add(AddNoteEvent(result));
              // setState(() {
              //   notes.insert(0, result);
              // });

              // widget.onNoteAdded?.call(result);
              // await _loadNotes();
            }
          }),
    );
  }
}
