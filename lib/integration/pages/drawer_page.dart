import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/features/drawer/drawer.dart';
import 'package:arfoon_note/integration/cubit/await_cubit/await_cubit.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  final AwaitCubit<List<Label>> labelsCubit;
  final void Function(Label) onLabelSelected;
  final void Function(Label)? onLabelAdded;
  final void Function(Label)? onLabelUpdate;
  final void Function(int id)? onLabelDelete;
   final VoidCallback onProfileTap;
   final VoidCallback onSettingTap;
   final AwaitCubit<String?> userNameCubit;

  const DrawerPage(
      {super.key,
      required this.onLabelSelected,
      this.onLabelAdded,
      this.onLabelUpdate,
      this.onLabelDelete, required this.labelsCubit, required this.onProfileTap, required this.onSettingTap, required this.userNameCubit});

  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
      userNameCubit: userNameCubit,
      labelsCubit: labelsCubit,
      onSettingTap:onSettingTap ,
      onProfileTap: onProfileTap,
    getLabels: api.noteServer.labels.list,
      addLabel: api.noteServer.labels.insert,
      deleteLabel: api.noteServer.labels.deleteLabel,
      updateLabel: api.noteServer.labels.updateLabel,
      onLabelSelected: onLabelSelected,
      onLabelAdded: onLabelAdded,
      onLabelDeleted: onLabelDelete,
      onLabelUpdated: onLabelUpdate, 
      userSavedName: api.localStorageService.getUserName,
      getTheme: api.themeRepository.loadTheme,
      saveTheme: api.themeRepository.saveTheme,
      
    );

  }
}
