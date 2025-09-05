import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/features/drawer/drawer.dart';
import 'package:arfoon_note/integration/await_cubit/await_cubit.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  final AwaitCubit<List<Label>> labelsCubit;
  final void Function(Label) onLabelSelected;
  final void Function(Label)? onLabelAdded;
  final void Function(Label)? onLabelUpdate;
  final void Function(int id)? onLabelDelete;
   final VoidCallback onProfileTap;

  const DrawerPage(
      {super.key,
      required this.onLabelSelected,
      this.onLabelAdded,
      this.onLabelUpdate,
      this.onLabelDelete, required this.labelsCubit, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
      getLabels: api.labels.list,
      addLabel: api.labels.insert,
      deleteLabel: api.labels.deleteLabel,
      updateLabel: api.labels.updateLabel,
      onLabelSelected: onLabelSelected,
      onLabelAdded: onLabelAdded,
      onLabelDeleted: onLabelDelete,
      onLabelUpdated: onLabelUpdate, onProfileTap: onProfileTap,
    );
  }
}
