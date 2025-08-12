import 'package:arfoon_note/frontend/features/add_note/add_note_example.dart';
import 'package:arfoon_note/frontend/features/add_note/add_note_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import '../../../theme/theme.dart';
import '../../widgets/widget.dart';
import 'widgets/home_widgets.dart';

class HomeView extends StatelessWidget {
  final List<String> categories;
  final int selectedCategoryIndex;
  final List<NoteCardData> notes;

  const HomeView({
    super.key,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:  HomeAppBar(
        leading: const Icon(Icons.menu),
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
            categories: categories,
            selectedIndex: selectedCategoryIndex,
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
      floatingActionButton: AddNoteButton(
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddNoteView()
                      )
                      
                      )
                      
                      ),
    );
  }
}
