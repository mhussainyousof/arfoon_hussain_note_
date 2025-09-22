import 'package:arfoon_note/frontend/theme/note_colors.dart';
import 'package:arfoon_note/integration/cubit/await_cubit/await_builder.dart';
import 'package:arfoon_note/integration/cubit/await_cubit/await_cubit.dart';
import 'package:arfoon_note/main.dart';
import 'package:arfoon_note/server/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

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
      final themeCubit = context.read<AwaitCubit<ThemeState>>();
    return AwaitBuilder<ThemeState>(
        getData: api.themeRepository.loadTheme,
        cubit:themeCubit,
        builder: (context, themeState) {
          final theme = themeState.data ?? ThemeState.system;

          
          return LocaleBuilder(
            builder: (locale) {
              return MaterialApp(            
            localizationsDelegates:Locales.delegates,
       
            supportedLocales: Locales.supportedLocales,
            locale: locale,
            
            debugShowCheckedModeBanner: false,
            title: 'Arfoon Note',
            theme: AppTheme.lightTheme(locale!),
            darkTheme: AppTheme.darkTheme(),
            themeMode: _getThemeMode(theme),
            home: widget.home,
                      );
            });
        },
      );
    }

    ThemeMode _getThemeMode(ThemeState themeState) {
      switch (themeState) {
        case ThemeState.system:
          return ThemeMode.system;
        case ThemeState.dark:
          return ThemeMode.dark;
        case ThemeState.light:
          return ThemeMode.light;
      }
    }
}
