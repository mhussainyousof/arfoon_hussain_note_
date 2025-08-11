import 'package:arfoon_note/frontend/frontend.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'home_view.dart';
import 'widgets/home_widgets.dart';

class HomeExample extends StatelessWidget {
  const HomeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeView(
      categories: const ["All Notes", "Home", "Office", "Note", "Design"],
      selectedCategoryIndex: 0,
      notes: [
        NoteCardData(
          date: "12 Sep",
          title: "Exploring Ideas",
          description:
              "Exploring ideas is the cornerstone of innovation and progress. It's the process of venturing beyond the familiar, questioning assumptions, and embracing the unknown.",
          tags: ["Office"],
          isPinned: true,
          isHighlighted: true,
        ),
        NoteCardData(
          date: "12 Sep",
          title: "Exploring Ideas",
          description:
              "Exploring ideas is the cornerstone of innovation and progress. It's the process of...",
          tags: ["Office", "Design"],
        ),
        NoteCardData(
          date: "12 Sep",
          title: "Exploring Ideas",
          description:
              "Exploring ideas is the cornerstone of innovation and progress. It's the process of venturing beyond the familiar...",
          tags: ["Office", "Design"],
        ),
      ],
    );
  }
}
