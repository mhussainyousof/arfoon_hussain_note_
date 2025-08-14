import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeView(
      categories: const [],
      selectedCategoryIndex: 0,
      getNotes: api.notes.list(),
      onNoteAdded: (note) {
        api.notes.insert(note); 
      },
    );
  }
}
