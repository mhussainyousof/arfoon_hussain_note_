import 'package:arfoon_note/client/client.dart';
import 'package:arfoon_note/frontend/features/drawer/setting_dialog/widgets/setting_languange.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/server/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingDialog extends StatefulWidget {
  final Future<NoteTheme> Function(Filter? filter) getTheme;
  final Future<void> Function(NoteTheme) saveTheme;

  const SettingDialog({super.key, required this.getTheme, required this.saveTheme});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
late final AwaitCubit<NoteTheme> themeCubit;

  @override
  void initState() {
    super.initState();
    themeCubit = context.read<AwaitCubit<NoteTheme>>();

  }
  @override
  Widget build(BuildContext context) {
    
    
    return AwaitBuilder<NoteTheme>(
      cubit: themeCubit,
      getData: widget.getTheme,
      builder: (context, themeState) {
        final currentTheme = themeState.data ?? NoteTheme.system;
        
        return NoteDialog(children: [
          const Icon(
            Icons.settings,
            size: 60,
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome to Arfoon Note',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          const SettingLanguage(
            text: 'Change Language',
            containerText: 'English',
          ),
          const SizedBox(height: 20),
          SettingLanguage(
            text: 'Change Theme',
            containerText: currentTheme.name,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => NoteDialog(
                  title: "Select Theme",
                  children: [
                    SimpleDialogOption(
                      child: const Text("System Theme"),
                      onPressed: () async {
                       await  widget.saveTheme(NoteTheme.system);
                        await themeCubit.refresh();
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: const Text("Light"),
                      onPressed: () async {
                        widget.saveTheme(NoteTheme.light);
                         themeCubit.refresh();
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: const Text("Dark"),
                      onPressed: () async {
                        widget.saveTheme(NoteTheme.dark);
                         themeCubit.refresh();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ]);
      },
    );
  }
}
