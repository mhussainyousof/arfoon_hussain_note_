import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/frontend/theme/responsive.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bidi_text/flutter_bidi_text.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

class CustomDrawer extends StatefulWidget {
  final Future<List<Label>> Function(Filter?) getLabels;
  final Future<Label?> Function(Label) updateLabel;
  final Future<void> Function(int) deleteLabel;
  final Future<Label> Function(Label) addLabel;
  final void Function(Label? label) onLabelSelected;
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
  final Label? selectedLabel;

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
      required this.selectedLabel,
     required this.userNameCubit});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userGreeting = 'welcome';

  //!
  // Consts
  static const _horizontalPadding = 16.0;
  static const _verticalPadding = 12.0;
  static const _iconSize = 24.0;
  static const _logoSize = 35.0;
  static const _textColor = Color(0XFF71717A);
  static const _labelTextColor = Color(0XFF73737E);
  static const _fontSizeSmall = 12.0;
  static const _fontSizeNormal = 14.0;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //!
            // Header section with app logo and name
            _drawerHeader(isDark),

            //!
            // Drawer item for navigating to "All Notes"
            _allNotesTIle(isDark),

            //! 
            // title for labels
             Padding( 
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8),
              child: BidiText(
                Locales.string(context, 'labels'),
                style: const TextStyle(
                  fontSize: 12,
                  color:_textColor,
                ),
              ),
            ),

            //!
            // List of user-defined labels with edit and select functionality
            _labelListView(),

            //! 
            // Bottom section with label adding and settings options
            _addLabelSetting(isDark),

            //! User info footer with initials, name, greeting, and a menu icon
            _userInfo(),
          ],
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: AwaitBuilder<String?>(
                  cubit: widget.userNameCubit,
                  getData: widget.userSavedName,
                  builder: (context, state) {
                    final name = state.data ?? 'guest';
                    return Row(
                      children: [

                        //!
                        // User two name and last name letters
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

                        //!
                        // User name and greeting text
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
                        //! 
                        // to change user name
                        IconButton(
                            icon: const Icon(Icons.unfold_more),
                            onPressed: () async {
                              widget.onProfileTap();
                            
                            }),
                      ],
                    );
                  }));
  }

  Widget _addLabelSetting(bool isDark) {
    return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                //! 
                // Button to add a new label
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
                //! 
                // Settings button
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
          );
  }

  Widget _labelListView() {
    return Expanded(
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
                     selected: widget.selectedLabel?.id == label.id,
                      selectedTileColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      horizontalTitleGap: 6,
                      leading: SvgPicture.asset('assets/images/label.svg',
                          width: 24, height: 24),
                      title: Text(label.name,
                          style: const TextStyle(
                              fontSize: _fontSizeNormal, color: _labelTextColor)),
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
          );
  }

  Widget _allNotesTIle(bool isDark) {
    return ListTile(
            horizontalTitleGap: 6,
            leading: SvgPicture.asset(
              'assets/images/all_notes.svg',
              colorFilter: ColorFilter.mode(
                isDark ? Colors.white : Colors.black,
                BlendMode.srcIn,
              ),
              width: _iconSize,
              height: _iconSize,
            ),
            title: const LocaleText(
              'all_notes',
              style: TextStyle(fontSize: _fontSizeNormal, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              widget.onLabelSelected(null);
              !Responsive.isMobile(context) ? null : Navigator.pop(context);
            },
          );
  }

  Widget _drawerHeader(bool isDark) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/note_logo.svg',
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                  width: _logoSize,
                  height: _logoSize,
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocaleText(
                      'think_note_achieve',
                      style:
                          TextStyle(fontSize: _fontSizeSmall, color: _textColor),
                    ),
                  ],
                ),
              ],
            ),
          );
  }


  
}
