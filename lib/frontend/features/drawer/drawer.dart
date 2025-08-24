import 'package:arfoon_note/frontend/theme/context_ext.dart';
import 'package:arfoon_note/integration/blocs/note/note_bloc.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../client/models/models.dart';
import '../../widgets/widget.dart';
import '../features.dart';

class CustomDrawer extends StatefulWidget {
  final String userName;
  final String userGreeting;
  final Future<List<Label>> Function(Filter?) getLabels;
  final Future<Label?> Function(Label) updateLabel;
  final Future<void> Function(int) deleteLabel;
  final Future<Label> Function(Label) addLabel;

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.userGreeting,
    required this.deleteLabel,
    required this.updateLabel,
    required this.getLabels,
    required this.addLabel
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late final AwaitCubit<List<Label>> awaitCubit;

  @override
  void initState() {
    super.initState();
    awaitCubit = AwaitCubit<List<Label>>();
    awaitCubit.load(api.labels.list, null);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      //! SafeArea to avoid system UI overlaps
      child: SafeArea(
        child: Column(
          children: [
            //! Header section with app logo and name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/note_logo.svg',
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.isMobile ? 'Mobile Note' : 'Desktop Note',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Think. Note. Achieve.',
                        style:
                            TextStyle(fontSize: 12, color: Color(0XFF71717A)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //! Drawer item for navigating to "All Notes"
            ListTile(
              horizontalTitleGap: 6,
              leading: SvgPicture.asset(
                'assets/images/all_notes.svg',
                width: 24,
                height: 24,
              ),
              title: const Text(
                'All Notes',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllNotesView()),
                );
              }, //! Navigation handler placeholder
            ),

            //! Section title for labels
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Labels',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0XFF71717A),
                  ),
                ),
              ),
            ),

            //! List of user-defined labels with edit and select functionality
            Expanded(
              child: AwaitBuilder<List<Label>>(
                cubit: awaitCubit,
                getData: widget.getLabels,
                builder: (context, state) {
                  if (state.status == AwaitStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.status == AwaitStatus.error) {
                    return Text('Error: ${state.error}');
                  }

                  final labels = state.data ?? [];
                  if (labels.isEmpty) {
                    return const Center(
                      child: Text('There is no label.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: labels.length,
                    itemBuilder: (context, index) {
                      final label = labels[index];
                      return ListTile(
                        onLongPress: () {
                          api.labels.deleteLabel(label.id!);
                        },
                        horizontalTitleGap: 6,
                        leading: SvgPicture.asset('assets/images/label.svg',
                            width: 24, height: 24),
                        title: Text(label.name,
                            style: const TextStyle(
                                fontSize: 14, color: Color(0XFF73737E))),
                        trailing: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/edit.svg',
                            width: 20,
                            height: 20,
                          ),
                          onPressed: () {
                            final TextEditingController controller =
                                TextEditingController(text: label.name);

                            showDialog(
                              context: context,
                              builder: (context) {
                                return NoteDialog(
                                  title: 'Edit Label',
                                  fontWeight: FontWeight.bold,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  details: 'Label Name',
                                  children: [
                                    const SizedBox(height: 8),
                                    NoteTextField(
                                      controller: controller,
                                      hintText: 'Enter label name',
                                    ),
                                    const SizedBox(height: 40),
                                    DialogButtons(
                                      isTextButton: true,
                                      textButtonText: 'Delete',
                                      elevatedButtonText: 'Update',
                                      textButtonOnpressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => NoteDialog(
                                            title:
                                                'Are you sure want to Delete?',
                                            details:
                                                'Once Deleted a label cannot be undo, are you sure want to Delete?',
                                            children: [
                                              const SizedBox(height: 15),
                                              //! Cancel and Delete buttons in confirmation dialog
                                              DialogButtons(
                                                  isTextButton: true,
                                                  textButtonElevation: 0,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  width: 15,
                                                  elevatedButtonOnpressed:
                                                      () async {
                                                    await widget
                                                        .deleteLabel(label.id!);

                                                    awaitCubit.refresh();
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  textButtonOnpressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  textButtonText: 'Cancel',
                                                  elevatedButtonText:
                                                      'Delete It.')
                                            ],
                                          ),
                                        );
                                      },

                                      // Update Label Button 
                                      elevatedButtonOnpressed: () async {
                                        final newName = controller.text.trim();
                                        if (newName.isNotEmpty) {
                                          final updatedLabel =
                                              label.copyWith(name: newName);
                                              await widget.updateLabel(updatedLabel);
                                          awaitCubit.refresh();
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),

                        onTap: () {}, //! Select label handler placeholder
                      );
                    },
                  );
                },
              ),
            ),

            //! Bottom section with label adding and settings options
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  //! Button to add a new label - opens dialog
                  ListTile(
                    horizontalTitleGap: 6,
                    leading: SvgPicture.asset('assets/images/Vector.svg',
                        width: 24, height: 24),
                    title:
                        const Text('Add Label', style: TextStyle(fontSize: 14)),
                    onTap: () {
                      final TextEditingController labelController =
                          TextEditingController();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return NoteDialog(
                              title: 'New Label',
                              fontWeight: FontWeight.bold,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              details: 'Label Name',
                              children: [
                                const SizedBox(height: 8),
                                NoteTextField(
                                  controller: labelController,
                                  hintText: 'A creative label name',
                                ),
                                const SizedBox(height: 40),

                                DialogButtons(
                                  isTextButton: true,
                                  elevatedButtonOnpressed: () async {
                                    final labeleName =
                                        labelController.text.trim();
                                    if (labeleName.isNotEmpty) {
                                      
                                      await widget.addLabel(Label(name: labeleName));
                                      awaitCubit.refresh();
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  textButtonText: 'Cancel',
                                  elevatedButtonText: 'Save Label',
                                  textButtonOnpressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                  ),

                  //! Settings button - opens settings dialog
                  ListTile(
                    horizontalTitleGap: 6,
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    ),
                    title:
                        const Text('Settings', style: TextStyle(fontSize: 14)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const SettingDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),

            //! User info footer with initials, name, greeting, and a menu icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      widget.userName.trim().isNotEmpty
                          ? widget.userName
                              .trim()
                              .split(' ')
                              .where((part) => part.isNotEmpty)
                              .map((part) => part[0].toUpperCase())
                              .take(2)
                              .join('')
                          : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),

                  //! User name and greeting text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.userGreeting,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),

                  //! Icon button for expanding additional options (functionality TBD)
                  IconButton(
                    icon: const Icon(Icons.unfold_more),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
