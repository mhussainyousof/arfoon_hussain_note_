import 'package:arfoon_note/frontend/theme/note_colors.dart';
import 'package:arfoon_note/integration/cubit/await_cubit/await_builder.dart';
import 'package:arfoon_note/integration/cubit/await_cubit/await_cubit.dart';
import 'package:arfoon_note/integration/cubit/await_cubit/await_state.dart';
import 'package:arfoon_note/main.dart';
import 'package:arfoon_note/server/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

  class FrontendApp extends StatefulWidget {
    const FrontendApp({
      super.key,
      required this.home,
    });
    final Widget home;

  @override
  State<FrontendApp> createState() => _FrontendAppState();
}

class _FrontendAppState extends State<FrontendApp> {
  
    @override
    Widget build(BuildContext context) {
      final themeCubit = context.read<AwaitCubit<AppTheme>>();
      return AwaitBuilder<AppTheme>(
        getData: api.themeRepository.loadTheme,
        cubit:themeCubit,
        builder: (context, themeState) {
          final theme = themeState.data ?? AppTheme.system;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Arfoon Note',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: _getThemeMode(theme),
            home: widget.home,
          );
        },
      );
    }

    ThemeMode _getThemeMode(AppTheme themeState) {
      switch (themeState) {
        case AppTheme.system:
          return ThemeMode.system;
        case AppTheme.dark:
          return ThemeMode.dark;
        case AppTheme.light:
          return ThemeMode.light;
      }
    }
}
