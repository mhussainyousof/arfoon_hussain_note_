
import 'package:arfoon_note/integration/blocs/note/note_bloc.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../client/models/models.dart';
import '../../theme/theme.dart';
import '../../widgets/widget.dart';
import '../features.dart';
import 'widgets/home_widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.getNotes,
    required this.addNote, required this.getLabels,
  });
  final Future<List<Note>> Function(Filter?) getNotes;
  final Future<List<Label>> Function(Filter?) getLabels;

  final Future<Note> Function(Note) addNote;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final searchController = TextEditingController();
  final notesCubit = AwaitCubit<List<Note>>();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: 
             const CustomDrawer(
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
          SearchNotesBar(
            controller: searchController,
            hintText: 'Search Notes',
            onChanged: (s) {
              notesCubit.filter(Filter(search: s));
            },
          ),
          const CategoryFilterChips(
            categories: [],
            selectedIndex: 0,
          ),
          Expanded(
            child: AwaitBuilder<List<Note>>(
              cubit: notesCubit,
              getData: widget.getNotes,
              builder: (context, state) {
                if (state.status == AwaitStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == AwaitStatus.error) {
                  return Center(child: Text('Error: ${state.error}'));
                }

                if (state.data == null || state.data!.isEmpty) {
                  return const Center(
                    child: Text('No Data found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.data!.length,
                  itemBuilder: (context, index) {
                    final note = state.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NoteCard(note: note),
                    );
                  },
                );
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
              MaterialPageRoute(builder: (context) => const AddNotePage()),
            );
            if (result is Note &&
                (((result.title ?? '').isNotEmpty) ||
                    (result.details ?? '').isNotEmpty)) {
              widget.addNote(result).then((v) {
                notesCubit.refresh();
              });
            }
          }),
    );
  }
}
