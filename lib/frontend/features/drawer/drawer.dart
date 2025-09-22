import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/frontend/theme/responsive.dart';
import 'package:arfoon_note/frontend/widgets/add_edit_label_dialog.dart';
import 'package:arfoon_note/frontend/widgets/sure_dialog_widget.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
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
  final VoidCallback onSettingTap;
  final Future<String?> Function(Filter?) userSavedName;
  final Future<ThemeState> Function(Filter? filter) getTheme;
  final Future<void> Function(ThemeState) saveTheme;
  final AwaitCubit<List<Label>> labelsCubit;
  final AwaitCubit<String?> userNameCubit;

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
      required this.saveTheme,
      required this.onSettingTap,
      required this.labelsCubit,
     required this.userNameCubit});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  String userGreeting = 'welcome';

  @override
  void initState() {
    super.initState();

    _loadUserName();


  }


 

  Future<void> _loadUserName() async {
    setState(() {
      userGreeting = _getGreeting();
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'good_morning';
    if (hour < 17) return 'good_afternoon';
    return 'good_evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Drawer(
        //! SafeArea to avoid system UI overlaps
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LocaleText(
                        'think_note_achieve',
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
              title: const LocaleText(
                'all_notes',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                widget.onLabelSelected(Label(name: '', id: null));
                !Responsive.isMobile(context) ? null : Navigator.pop(context);
              },
            ),

            //! Section title for labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: isRTL(context)
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: const LocaleText(
                  'labels',
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
                cubit: widget.labelsCubit,
                getData: widget.getLabels,
                builder: (context, state) {
                  if (state.status == AwaitStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.status == AwaitStatus.error ) {
                    return Text('Error: ${state.error}');
                  }

                  final labels = state.data ?? [];
                  if (labels.isEmpty) {
                    return const Center(
                      child: LocaleText('no_label'),
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
                           AddEditLabelView(
                            initialValue: label.name,
                             title: 'label_name',
                            details: 'label_name',
                              onSubmit: (newLabel)async{
                                if(newLabel.isNotEmpty){
                              await   widget.updateLabel(label.copyWith(name: newLabel));
                                 await widget.labelsCubit.refresh();
                               
                                  if(widget.onLabelUpdated != null){
                                   widget.onLabelUpdated!(label.copyWith(name: newLabel));
                                  }
                                }
                              },
                               onDelete: ()async{
                                SureView(
                                  title: 'delete',
                                  subTitle: 'delete_warning',
                                  sureText: 'delete',
                                  onSure: ()async{
                                  await widget.deleteLabel(label.id!);
                                  await widget.labelsCubit.refresh();
                                  if(widget.onLabelDeleted != null) widget.onLabelDeleted!(label.id!);
                                  Navigator.pop(context);
                                }).show(context);
                               }).show(context);
                          },
                        ),

                        onTap: () {
                          widget.onLabelSelected(label);
                          Responsive.isDesktop(context)
                              ? null
                              : Navigator.pop(context);
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
                    title: const LocaleText('add_label',
                        style: TextStyle(fontSize: 14)),
                    onTap: () {

                      AddEditLabelView(
                        initialValue: null,
                        title: 'new_label',
                        details: 'label_name',
                        onSubmit: (labelName)async{
                          if(labelName.isNotEmpty){
                            final newLabel = await widget.addLabel(Label(name: labelName));
                            await widget.labelsCubit.refresh();
                            if(widget.onLabelAdded != null){
                              widget.onLabelAdded!(newLabel);
                            }
                          }
                        },
                        onDelete: ()=> Navigator.pop(context),
                      ).show(context);

                    },
                  ),
                  //! Settings button - opens settings dialog

                  ListTile(
                      horizontalTitleGap: 6,
                      leading: const Icon(
                        Icons.settings_outlined,
                      ),
                      title: const LocaleText('settings',
                          style: TextStyle(fontSize: 14)),
                      onTap: () async {
                        widget.onSettingTap();
                      })
                ],
              ),
            ),

            //! User info footer with initials, name, greeting, and a menu icon
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: AwaitBuilder<String?>(
                    cubit: widget.userNameCubit,
                    getData: widget.userSavedName,
                    builder: (context, state) {
                      final name = state.data ?? 'guest';
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
                              LocaleText(
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
                                // !Responsive.isMobile(context)
                                //     ? null
                                //     : Navigator.pop(context);
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
