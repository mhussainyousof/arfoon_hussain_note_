import 'package:arfoon_note/client/models/note.dart';
import 'package:arfoon_note/frontend/features/add_note/add_note_view.dart';
import 'package:arfoon_note/frontend/features/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/theme.dart';
import '../../widgets/widget.dart';
import 'widgets/home_widgets.dart';

class HomeView extends StatefulWidget {
  final List<String> categories;
  final int selectedCategoryIndex;
  final Future<List<Note>> getNotes;
  final Function(Note)? onNoteAdded;

  const HomeView({
    super.key,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.getNotes,
    this.onNoteAdded,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note> notes = [];
  // bool loading = false;
  // String? error;

  _loadNotes() async {
    // setState(() {
    //   // loading = true;
    //   // error = null;
    // });
    try {
      notes = await widget.getNotes;
    } catch (e) {
      // error = e.toString();
    } finally {
      // loading = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    _loadNotes();
    super.initState();
  }

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
          builder: (context) =>
            GestureDetector(
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
          CategoryFilterChips(
            categories: widget.categories,
            selectedIndex: widget.selectedCategoryIndex,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NoteCard(data: note),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: 
      // widget.onNoteAdded == null
      //     ? null
      //     :
           AddNoteButton(
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddNoteView()),
                )
                .then((note) {
                  if (note is Note) {
                    widget.onNoteAdded?.call(note);
                  }
                });
              }),
    );
  }
}
