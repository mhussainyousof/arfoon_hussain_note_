import 'package:arfoon_note/integration/integration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../client/models/models.dart';
import '../../theme/theme.dart';
import '../../widgets/widget.dart';
import '../features.dart';
import 'widgets/home_widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.getNotes,
    required this.addNote,
    required this.getLabels,
  });
  final Future<List<Note>> Function(Filter?) getNotes;
  final Future<List<Label>> Function(Filter?) getLabels;
  final Future<Note> Function(Note) addNote;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final searchController = TextEditingController();
  final notesCubit = AwaitCubit<List<Note>>();
  final labelsCubit = AwaitCubit<List<Label>>();
  int selectedChipIndex = 0;
  Label? selectedLabel;

  @override
  void initState() {
    super.initState();
    notesCubit.load(widget.getNotes, null, inital: true);
    labelsCubit.load(widget.getLabels, null, inital: true);
  }

  @override
  void dispose() {
    searchController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerPage(
        labelsCubit: labelsCubit,
        onLabelSelected: applyFilter,
        onLabelAdded: (newlable) async {
          labelsCubit.refresh();
        },
        onLabelDelete: (id) async {
          labelsCubit.refresh();
          notesCubit.refresh(filter: notesCubit.state.filter);
        },
        onLabelUpdate: (udatedLabel) async {
          labelsCubit.refresh();
          notesCubit.refresh(filter: notesCubit.state.filter);
        },
      ),
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Icon(Icons.menu),
          ),
        ),
        title: 'Arfoon Note',
        textNaighbor: SvgPicture.asset(
          'assets/images/note_logo.svg',
          width: 24,
          height: 24,
        ),
      ),
      body: Column(
        children: [
          SearchNotesBar(
            controller: searchController,
            hintText: 'Search Notes',
            onChanged: (s) {
              notesCubit.filter(Filter(search: s));
            },
          ),

          // list of labels:
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

          Expanded(
            child: AwaitBuilder<List<Note>>(
              cubit: notesCubit,
              getData: widget.getNotes,
              builder: (context, state) {
                if (state.status == AwaitStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == AwaitStatus.error) {
                  return Center(child: Text('Error: ${state.error}'));
                }

                if (state.data == null || state.data!.isEmpty) {
                  return const Center(
                    child: Text('No Data found'),
                  );
                }
                final currentLabels = labelsCubit.state.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.data!.length,
                  itemBuilder: (context, index) {
                    final note = state.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NoteCard(
                        note: note,
                        getLabels: widget.getLabels,
                        allLabels: currentLabels,
                        labelsCubit: labelsCubit,
                        notesCubit: notesCubit,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AddNoteButton(
          child: const Icon(Icons.add, color: Colors.white),
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
          }),
    );
  }
}
