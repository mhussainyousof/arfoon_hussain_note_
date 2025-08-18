import 'package:arfoon_note/client/open_isar.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/blocs/label/label_bloc.dart';
import 'package:arfoon_note/integration/blocs/note/note_bloc.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/integration/main_app.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

// late NoteServer api;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Isar.initializeIsarCore();

//   final dir = await getApplicationDocumentsDirectory();
//   final isar = await openIsar(dir.path);
//   api = NoteServer.instance(isar);

//   if (kReleaseMode) {
//     runApp(const MainApp());
//     return;
//   }
//   runApp(const FrontendApp(home: ExamplePage()));
// }


import 'package:arfoon_note/client/open_isar.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/integration/main_app.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

late NoteServer api;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Isar.initializeIsarCore();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await openIsar(dir.path);
  api = NoteServer.instance(isar);

  if (kReleaseMode) {
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => NotesBloc(api)..add(LoadNotesEvent()),
          ),
          BlocProvider(
            create: (_) => LabelsBloc(api)..add(LoadLabelEvent()),
          ),
        ],
        child: const MainApp(),
      ),
    );
    return;
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotesBloc(api)..add(LoadNotesEvent()),
        ),
        BlocProvider(
          create: (_) => LabelsBloc(api)..add(LoadLabelEvent()),
        ),
      ],
      child: const FrontendApp(home: ExamplePage()),
    ),
  );
}
