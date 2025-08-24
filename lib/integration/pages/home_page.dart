import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/widgets.dart';

  class HomePage extends StatelessWidget {
    const HomePage({super.key});

    @override
    Widget build(BuildContext context) {
      return HomeView(
        addNote: api.notes.insert,
        getNotes: api.notes.list,
        getLabels: api.labels.list,
      );
    }
  }
