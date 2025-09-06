import 'package:arfoon_note/frontend/features/drawer/setting_dialog/widgets/setting_languange.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeCubit, ThemeState>(
      listener: (context, state) {
      },
      child: NoteDialog(children: [
        const Icon(
          Icons.settings,
          size: 60,
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome to Arfoon Note',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 30,
        ),
        const SettingLanguage(
          text: 'Change Language',
          containerText: 'English',
        ),
        const SizedBox(height: 20),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return SettingLanguage(
              text: 'Change Theme',
              containerText: _getThemeText(state),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text("Select Theme"),
                    children: [
                      SimpleDialogOption(
                          child: const Text("System Theme"),
                          onPressed: () {
                            context
                                .read<ThemeCubit>()
                                .setThemeMode(ThemeState.system);
                            Navigator.pop(context);
                          }),
                      SimpleDialogOption(
                          child: const Text("Light"),
                          onPressed: () {
                            context
                                .read<ThemeCubit>()
                                .setThemeMode(ThemeState.light);
                            Navigator.pop(context);
                          }),
                      SimpleDialogOption(
                          child: const Text("Dark"),
                          onPressed: () {
                            context
                                .read<ThemeCubit>()
                                .setThemeMode(ThemeState.dark);
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ]),
    );
  }

  String _getThemeText(ThemeState themeState) {
    switch (themeState) {
      case ThemeState.system:
        return 'System Theme';
      case ThemeState.light:
        return 'Light';
      case ThemeState.dark:
        return 'Dark';
    }
  }
}
