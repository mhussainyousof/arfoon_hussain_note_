import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:arfoon_note/frontend/features/drawer/setting_dialog/widgets/setting_option.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/server/theme.dart';

class SettingView {
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;
  final ThemeState currentTheme;
  final ValueChanged<ThemeState> onThemeChanged;
  SettingView({
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.currentTheme,
    required this.onThemeChanged,
  });
  void show(BuildContext context) {
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) => SettingDialog(
        currentLangugage: currentLanguage,
        onLanguageChanged: onLanguageChanged,
        currentTheme: currentTheme,
        onThemeChanged: onThemeChanged,
      ),
    );
  }
}


class SettingDialog extends StatefulWidget {
  final String currentLangugage;
  final ValueChanged<String> onLanguageChanged;
  final ThemeState currentTheme;
  final ValueChanged<ThemeState> onThemeChanged;
  const SettingDialog({
    super.key,
    required this.currentLangugage,
    required this.onLanguageChanged,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  late String _currentlanguage;
  late ThemeState _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentlanguage = widget.currentLangugage;
    _currentTheme = widget.currentTheme;
  }
//!
// mao of languages
  final _languages = {
    'en': 'English',
    'fa': 'فارسی',
    'ps': 'پښتو',
  };
//!
// List of themes
  final _themes = [
    ThemeState.system,
    ThemeState.light,
    ThemeState.dark,
  ];

  @override
  Widget build(BuildContext context) {
    return NoteDialog(
      children: [
      const Icon(
        Icons.settings,
        size: 60,
      ),
      const SizedBox(height: 20),
      const LocaleText('Setting'),
      const SizedBox(height: 30),

      //!
      // Language option
      SettingOption(
        isLocaleText: false,
        labelKey: 'change_language',
        valueText: _languages[_currentlanguage] ?? 'English',
        onPressed: () {
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) => NoteDialog(
              children: _languages.entries.map((entry){
                return SimpleDialogOption(
                  child: Text(entry.value),
                  onPressed: () {
                    setState(()=> _currentlanguage=entry.key);
                    widget.onLanguageChanged(entry.key);
                    Navigator.pop(context);
                  },
                );
              }).toList()
            ),
          );
        },
      ),


      const SizedBox(height: 20),

      //!
      // Theme option
      SettingOption(
        labelKey: 'change_theme',
        valueText: _currentTheme.name,
        // isLocaleText: true,
        onPressed: () {
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) => NoteDialog(
              children: 
              _themes.map((theme){
                return SimpleDialogOption(
                  child: LocaleText(theme.name),
                  onPressed: () {
                    setState(()=> _currentTheme=theme);
                    widget.onThemeChanged(theme);
                    Navigator.pop(context);
                  },
                );
              }).toList()
            ),
          );
        },
      )
    ]);
  }
}
