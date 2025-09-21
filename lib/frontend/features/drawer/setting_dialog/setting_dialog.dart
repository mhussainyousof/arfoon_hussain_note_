import 'package:arfoon_note/client/client.dart';
import 'package:arfoon_note/frontend/features/drawer/setting_dialog/widgets/setting_languange.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/server/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';



class SettingDialog extends StatefulWidget {
  final Future<ThemeState> Function(Filter? filter) getTheme;
  final Future<void> Function(ThemeState) saveTheme;

  const SettingDialog({
    super.key,
    required this.getTheme,
    required this.saveTheme,
  });

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  late final AwaitCubit<ThemeState> themeCubit;
  ThemeState? _currentTheme;

  @override
  void initState() {
    super.initState();
    themeCubit = context.read<AwaitCubit<ThemeState>>();
    _loadCurrentTheme();
  }

  Future<void> _loadCurrentTheme() async {
    final themeState = await widget.getTheme(null);
    setState(() {
      _currentTheme = themeState;
    });
  }

  Future<void> _changeTheme(ThemeState newTheme) async {
    await widget.saveTheme(newTheme);
    Navigator.pop(context);
    await themeCubit.refresh();
    setState(() {
      _currentTheme = newTheme;
    });
  }

  String _getCurrentLanguageName(BuildContext context) {
    final currentLocale = Locales.currentLocale(context)?.languageCode;
    
    switch (currentLocale) {
      case 'en':
        return 'English';
      case 'fa':
        return 'فارسی';
      case 'ps':
        return 'پښتو';
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return NoteDialog(children: [
      const Icon(
        Icons.settings,
        size: 60,
      ),
      const SizedBox(height: 20),
      const LocaleText('welcome'),
      const SizedBox(height: 30),
      SettingLanguage(
        isLocaleText: false,
        text: 'change_language',
        containerText: _getCurrentLanguageName(context),
        onPressed: () {
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) => NoteDialog(children: [
              SimpleDialogOption(
                child: const Text('English'),
                onPressed: () {
                  LocaleNotifier.of(context)!.change('en');
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              SimpleDialogOption(
                child: const Text('فارسی'),
                onPressed: () {
                  LocaleNotifier.of(context)!.change('fa');
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              SimpleDialogOption(
                child: const Text('پښتو'),
                onPressed: () {
                  LocaleNotifier.of(context)!.change('ps');
                  Navigator.pop(context);
                  setState(() {});
                },
              )
            ]),
          );
        },
      ),
      const SizedBox(height: 20),
      SettingLanguage(
        text: 'change_theme',
        containerText: _currentTheme?.name ?? 'Loading...',
        onPressed: () {
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) => NoteDialog(
              children: [
                SimpleDialogOption(
                  child: const LocaleText("system"),
                  onPressed: () => _changeTheme(ThemeState.system),
                ),
                SimpleDialogOption(
                  child: const LocaleText("light"),
                  onPressed: () => _changeTheme(ThemeState.light),
                ),
                SimpleDialogOption(
                  child: const LocaleText("dark"),
                  onPressed: () => _changeTheme(ThemeState.dark),
                ),
              ],
            ),
          );
        },
      )
    ]);
  }
}