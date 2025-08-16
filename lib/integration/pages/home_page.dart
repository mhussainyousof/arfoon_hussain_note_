import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/blocs/note_bloc.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (context) => NotesBloc(api)..add(LoadNotes()),
      child: const HomeView(

      ),
    );
  }
}
