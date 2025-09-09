import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/frontend/theme/context_ext.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CustomDrawer extends StatefulWidget {
  final Future<List<Label>> Function(Filter?) getLabels;
  final Future<Label?> Function(Label) updateLabel;
  final Future<void> Function(int) deleteLabel;
  final Future<Label> Function(Label) addLabel;
  final void Function(Label label) onLabelSelected;
  final void Function(Label label)? onLabelAdded;
  final void Function(Label label)? onLabelUpdated;
  final void Function(int id)? onLabelDeleted;
  final VoidCallback onProfileTap;
  final Future<String?> Function(Filter?) userSavedName;
  final Future<AppTheme> Function(Filter? filter) getTheme;
  final Future<void> Function(AppTheme) saveTheme;

  const CustomDrawer(
      {super.key,
      required this.deleteLabel,
      required this.updateLabel,
      required this.getLabels,
      required this.addLabel,
      required this.onLabelSelected,
      this.onLabelAdded,
      this.onLabelUpdated,
      this.onLabelDeleted,
      required this.onProfileTap,
      required this.userSavedName,
      required this.getTheme,
      required this.saveTheme});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late final AwaitCubit<List<Label>> awaitCubit;
  late final AwaitCubit<String?> userNameCubit;
  // late final AwaitCubit<ThemeState> themeCubit;

  String userGreeting = 'Welcome';

  @override
  void initState() {
    super.initState();
    awaitCubit = AwaitCubit<List<Label>>();
    userNameCubit = AwaitCubit<String?>();
    // themeCubit = AwaitCubit<ThemeState>();
    awaitCubit.load(widget.getLabels, null);
    userNameCubit.load(widget.userSavedName, null);
    // themeCubit.load(widget.getTheme, null);

    _loadUserName();
  }

  Future<void> _loadUserName() async {
    setState(() {
      userGreeting = _getGreeting();
    });
  }

  // void _onDrawerOpened() {
  //   _loadUserName();
  // }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
     final themeCubit = context.read<AwaitCubit<AppTheme>>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _onDrawerOpened();
    // });
    return Drawer(
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
                    colorFilter: ColorFilter.mode(
                      isDark ? Colors.white : Colors.black,
                      BlendMode.srcIn,
                    ),
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
                colorFilter: ColorFilter.mode(
                  isDark ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              title: const Text(
                'All Notes',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                widget.onLabelSelected(Label(name: '', id: null));
                Navigator.pop(context);
              },
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
                                    CustomeTextField(
                                      controller: controller,
                                      hintText: 'Enter label name',
                                    ),
                                    const SizedBox(height: 40),
                                    DialogButtons(
                                      showSecondary: true,
                                      secondaryButtonText: 'Delete',
                                      primaryButtonText: 'Update',
                                      secondaryButtonOnPressed: () {
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
                                                  showSecondary: true,
                                                  secondaryButtonElevation: 0,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  width: 15,
                                                  primaryButtonOnPressed:
                                                      () async {
                                                    await widget
                                                        .deleteLabel(label.id!);

                                                    awaitCubit.refresh();

                                                    //! Notifiy Home view
                                                    if (widget.onLabelDeleted !=
                                                        null) {
                                                      widget.onLabelDeleted!(
                                                          label.id!);
                                                    }
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  secondaryButtonOnPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  secondaryButtonText: 'Cancel',
                                                  primaryButtonText:
                                                      'Delete It.')
                                            ],
                                          ),
                                        );
                                      },

                                      // Update Label Button
                                      primaryButtonOnPressed: () async {
                                        final newName = controller.text.trim();
                                        if (newName.isNotEmpty) {
                                          final updatedLabel =
                                              label.copyWith(name: newName);
                                          await widget
                                              .updateLabel(updatedLabel);
                                          awaitCubit.refresh();

                                          if (widget.onLabelUpdated != null) {
                                            widget
                                                .onLabelUpdated!(updatedLabel);
                                          }
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

                        onTap: () {
                          widget.onLabelSelected(label);
                          Navigator.pop(context);
                        }, //! Select label handler placeholder
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
                        colorFilter: ColorFilter.mode(
                          isDark ? Colors.white : Colors.black,
                          BlendMode.srcIn,
                        ),
                        width: 24,
                        height: 24),
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
                                CustomeTextField(
                                  controller: labelController,
                                  hintText: 'A creative label name',
                                ),
                                const SizedBox(height: 40),
                                DialogButtons(
                                  showSecondary: true,
                                  primaryButtonOnPressed: () async {
                                    final labeleName =
                                        labelController.text.trim();
                                    if (labeleName.isNotEmpty) {
                                      await widget
                                          .addLabel(Label(name: labeleName));
                                      awaitCubit.refresh();
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                      if (widget.onLabelAdded != null) {
                                        widget.onLabelAdded!(
                                            Label(name: labeleName));
                                      }
                                    }
                                  },
                                  secondaryButtonText: 'Cancel',
                                  primaryButtonText: 'Save Label',
                                  secondaryButtonOnPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                  ),
                  //! Settings button - opens settings dialog
                  AwaitBuilder(
                      cubit:themeCubit ,
                      getData: widget.getTheme,
                      builder: (context, themeState) {
                        return ListTile(
                            horizontalTitleGap: 6,
                            leading: const Icon(
                              Icons.settings_outlined,
                            ),
                            title: const Text('Settings',
                                style: TextStyle(fontSize: 14)),
                            onTap: () async{
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SettingDialog(
                                      getTheme:  widget.getTheme,
                                      saveTheme: widget.saveTheme);
                                },
                              
                              );
                                if(themeState.data != null){
                                 await themeCubit.refresh();
                                }
                            });
                      })
                ],
              ),
            ),

            //! User info footer with initials, name, greeting, and a menu icon
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: AwaitBuilder<String?>(
                    cubit: userNameCubit,
                    getData: widget.userSavedName,
                    builder: (context, state) {
                      final name = state.data ?? 'Guest';
                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              name.trim().isNotEmpty
                                  ? name
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
                                name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userGreeting,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          const Spacer(),
                          //! Icon button for expanding additional options (functionality TBD)
                          IconButton(
                              icon: const Icon(Icons.unfold_more),
                              onPressed: () async {
                                widget.onProfileTap();
                                Navigator.pop(context);
                              }),
                        ],
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
