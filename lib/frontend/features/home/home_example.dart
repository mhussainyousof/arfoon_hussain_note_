import 'package:arfoon_note/frontend/frontend.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'; 

class HomeExample extends StatelessWidget {
  const HomeExample({super.key});
  @override
  Widget build(BuildContext context) {
    return const HomeView(
      // categories: const ["All Notes", "Home", "Office", "Note", "Design"],
      // selectedCategoryIndex: 0,
      // getNotes: Future.value([
      //   Note(
      //       title: "Exploring Ideas",
      //       details:
      //           "Exploring ideas is the cornerstone of innovation and progress. It's the process of venturing beyond the familiar, questioning assumptions, and embracing the unknown.",
      //       // labelIds: ["Office"],
      //       // createdAt: DateTime.now(),
      //       labelIds: []),
      //   Note(
      //       title: "Designing Tomorrow",
      //       details:
      //           "Designing tomorrow requires a blend of creativity and practicality. It's about envisioning a future that is both innovative and sustainable.",
      //       labelIds: []),
      // ]),
      // getNotes: [
      //   NoteCardData(
      //     date: "12 Sep",
      //     title: "Exploring Ideas",
      //     description:
      //         "Exploring ideas is the cornerstone of innovation and progress. It's the process of venturing beyond the familiar, questioning assumptions, and embracing the unknown.",
      //     tags: ["Office"],
      //     isPinned: true,
      //     isHighlighted: true,
      //   ),
      //   NoteCardData(
      //     date: "12 Sep",
      //     title: "Exploring Ideas",
      //     description:
      //         "Exploring ideas is the cornerstone of innovation and progress. It's the process of...",
      //     tags: ["Office", "Design"],
      //   ),
      //   NoteCardData(
      //     date: "12 Sep",
      //     title: "Exploring Ideas",
      //     description:
      //         "Exploring ideas is the cornerstone of innovation and progress. It's the process of venturing beyond the familiar...",
      //     tags: ["Office", "Design"],
      //   ),
      // ],
    );
  }
}
