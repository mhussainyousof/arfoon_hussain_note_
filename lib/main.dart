import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/cubit/await_cubit/await_cubit.dart';
import 'package:arfoon_note/integration/main_app.dart';
import 'package:arfoon_note/server/app_service.dart';
import 'package:arfoon_note/server/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:isar/isar.dart';

late AppService api;
void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Isar.initializeIsarCore();

  // init Language
  await Locales.init(['en', 'fa', 'ps']);

  // init all services
  api = await AppService.init();

  // init theme
  final themeCubit = AwaitCubit<ThemeState>();

  runApp(
    BlocProvider.value(
      value: themeCubit,
      child:
          const FrontendApp(home: kReleaseMode ? MainApp() : ExamplePage())));
}
