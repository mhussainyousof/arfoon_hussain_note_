import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/frontend/features/profile_view/profile_view.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';

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
