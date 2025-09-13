import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
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
    final currentName = await api.localStorageService.getUserName(null) ?? '';
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) => ProfileEditDialog(
        currentName: currentName,
        onNameSaved: (newName) async {
          await api.localStorageService.saveUserName(newName);
          Navigator.pop(context);
        },
      ),
    );
  }


//!
  // shows setting dialog
  void _onSettingTap(BuildContext context) {
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return SettingDialog(
            getTheme: api.themeRepository.loadTheme,
            saveTheme: api.themeRepository.saveTheme);
      },
    );
  }
}
