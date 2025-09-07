import 'package:arfoon_note/frontend/theme/note_colors.dart';
import 'package:arfoon_note/integration/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FrontendApp extends StatelessWidget {
  const FrontendApp({super.key, required this.home, });
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
    title: 'Arfoon Note',
    theme: AppTheme.lightTheme(),
    
    // ThemeData(
    //   fontFamily: 'Geist',
    //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
    //   useMaterial3: true,
      
    // ),
    
    darkTheme: AppTheme.darkTheme(),
    themeMode: _getThemeMode(themeState) ,
    home: home,
        );
      },
    );
  }

  ThemeMode _getThemeMode (ThemeState themeState){
    switch(themeState){
      case ThemeState.system:
       return ThemeMode.system;
      case ThemeState.dark:
        return ThemeMode.dark;
      case ThemeState.light:
        return ThemeMode.light;
    }
  }
}
