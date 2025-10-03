import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/frontend/widgets/profile_view_dialog.dart';
import 'package:arfoon_note/main.dart';
import 'package:arfoon_note/server/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

class HomePage extends StatelessWidget {
  final userNameCubit = AwaitCubit<String?>();
  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return HomeView(
        addNote: api.noteServer.notes.insert,
        getNotes: api.noteServer.notes.list,
        getLabels: api.noteServer.labels.list,
        onProfileTap: () => _onProfileTap(context),
        onSettingTap: () => _onSettingTap(context));
  }

//!
  // shows profile edit dialog
  void _onProfileTap(BuildContext context) async {
    final currentName = await api.localStorageService.getUserName(null);
    ProfileView(
        title: currentName?.isEmpty ?? true
            ? 'welcome_to_arfoon_note'
            : 'edit_profile',
        submitText: currentName?.isEmpty ?? true ? 'continue' : 'save',
        currentName: currentName,
        onSubmit: (newName) async {
          await api.localStorageService.saveUserName(newName!);
          await userNameCubit.refresh();
        }).show(context);
  }

//!
  // shows setting dialog
  void _onSettingTap(BuildContext context) async{
  final currentLanguage = Locales.currentLocale(context)?.languageCode ?? 'en';
  final currentTheme = await api.themeRepository.loadTheme(null);

  
  SettingView(
    currentLanguage: currentLanguage,
     onLanguageChanged: (lang){
      LocaleNotifier.of(context)!.change(lang);
     },
      currentTheme: currentTheme,
       onThemeChanged: (t)async{
        await api.themeRepository.saveTheme(t);
        await context.read<AwaitCubit<ThemeState>>().refresh();
       }).show(context);
  }
}
