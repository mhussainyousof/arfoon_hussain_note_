import 'package:flutter/material.dart';
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: HomeAppBar(),
      ),
      body: Column(
        children: [
          const SearchNotesBar(hintText: 'Search Notes',),
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
      floatingActionButton: const AddNoteButton(),
    );
  }
}
