import 'package:arfoon_note/frontend/features/home/widgets/home_desktop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:arfoon_note/frontend/features/home/home.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/frontend/theme/responsive.dart';
import 'package:arfoon_note/integration/integration.dart';
import '../../../client/models/models.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.getNotes,
    required this.addNote,
    required this.getLabels,
    required this.onProfileTap,
    required this.onSettingTap,
  });
  final Future<List<Note>> Function(Filter?) getNotes;
  final Future<List<Label>> Function(Filter?) getLabels;
  final Future<Note> Function(Note) addNote;
  final VoidCallback onProfileTap;
  final VoidCallback onSettingTap;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final searchController = TextEditingController();
  late final AwaitCubit<List<Note>> notesCubit;
  late final AwaitCubit<List<Label>> labelsCubit;
  int selectedChipIndex = 0;
  Label? selectedLabel;
  Note? selectedNote;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    notesCubit = AwaitCubit<List<Note>>();
    labelsCubit = AwaitCubit<List<Label>>();
  }

  @override
  void dispose() {
    searchController.dispose();
    notesCubit.close();
    labelsCubit.close();
    super.dispose();
  }

  void applyFilter(Label? label) {
    setState(() {
      selectedLabel = label;
      final labels = labelsCubit.state.data ?? [];
      selectedChipIndex =
          label == null ? 0 : labels.indexWhere((l) => l.id == label.id) + 1;
    });
    notesCubit.filter(Filter(label: (label?.id != null) ? label : null));
  }

  void selectNote(Note note) {
    setState(() {
      selectedNote = note;
      isEditing = true;
    });
  }

  void createNote() {
    setState(() {
      selectedNote = null;
      isEditing = false;
    });
  }

  Future<Note> desktopSaveNote(Note note) async {
    final savedNote = await widget.addNote(note);
    await notesCubit.refresh();
    await labelsCubit.refresh();
    return savedNote;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    final homePage = context.findAncestorWidgetOfExactType<HomePage>();
    final userNameCubit = homePage?.userNameCubit;

    final drawerWidget = DrawerPage(
      userNameCubit: userNameCubit!,
      labelsCubit: labelsCubit,
      onLabelSelected: applyFilter,
      onLabelAdded: (newLabel) async {
        await labelsCubit.refresh();
      },
      onLabelDelete: (id) async {
        await labelsCubit.refresh();
        await notesCubit.refresh(filter: notesCubit.state.filter);
      },
      onLabelUpdate: (updatedLabel) async {
        await labelsCubit.refresh();
        notesCubit.refresh(filter: notesCubit.state.filter);
      },
      onProfileTap: widget.onProfileTap,
      onSettingTap: widget.onSettingTap,
    );
    return Material(
      child: Row(
        children: [
          //!
          // Drawer in Desktop and Tablet Sizes
          if (!isMobile)
            DesktopAndTabletDrawer(isDark: isDark, drawerWidget: drawerWidget),

          Expanded(
            child: Scaffold(
                drawer: !isMobile ? null : drawerWidget,
                appBar: isMobile
                    ? HomeAppBar(
                        leading: !isMobile
                            ? null
                            : Builder(
                                builder: (context) => GestureDetector(
                                  onTap: () =>
                                      Scaffold.of(context).openDrawer(),
                                  child: const Icon(Icons.menu),
                                ),
                              ),
                        title: 'arfoon_note',
                        textNaighbor: SvgPicture.asset(
                          'assets/images/note_logo.svg',
                          colorFilter: ColorFilter.mode(
                            isDark ? Colors.white : Colors.black,
                            BlendMode.srcIn,
                          ),
                          width: 24,
                          height: 24,
                        ),
                      )
                    : null,
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [

                      //!
                      // Header for Desktop
                      if (isDesktop) DesktopHeader(createNote: createNote),

                      SearchNotesBar(
                        controller: searchController,
                        hintText: 'search_notes',
                        onChanged: (s) {
                          notesCubit.filter(Filter(
                            search: s,
                            label: selectedLabel,
                          ));
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // list of labels:
                      if (isMobile)
                        AwaitBuilder(
                            getData: widget.getLabels,
                            cubit: labelsCubit,
                            builder: (context, state) {
                              final labels = state.data ?? [];
                              return CategoryFilterChips(
                                labels: labels,
                                selectedIndex: selectedChipIndex,
                                onSelectLabel: applyFilter,
                              );
                            }),

                      NotesList(
                          getNotes: widget.getNotes,
                          getLabels: widget.getLabels,
                          notesCubit: notesCubit,
                          labelsCubit: labelsCubit,
                          selectNote: selectNote,
                          isMobile: isMobile,
                          isDesktop: isDesktop),
                    ],
                  ),
                ),
                floatingActionButton: isDesktop
                    ? null
                    : AddNoteButton(
                        child: const Icon(
                          Icons.add,
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditNoteView(
                                onSave: widget.addNote,
                                getLabels: widget.getLabels,
                                initialLabel: selectedLabel,
                              ),
                            ),
                          );

                          if (result != null) {
                            await notesCubit.refresh();
                            await labelsCubit.refresh();
                          }
                        })),
          ),
          if (isDesktop)
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AddEditNoteView(
                  onSave: desktopSaveNote,
                  getLabels: widget.getLabels,
                  initialLabel: selectedLabel,
                  note: selectedNote,
                  key: ValueKey(selectedNote?.id ?? 'new'),
                  noteCubit: notesCubit,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
