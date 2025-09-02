import 'package:arfoon_note/frontend/features/home/widgets/home_appbar.dart';
import 'package:arfoon_note/frontend/widgets/widget.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../client/client.dart';
import '../../theme/theme.dart';

class AddEditNoteView extends StatefulWidget {
  final Note? note;
  final Future<List<Label>> Function(Filter?) getLabels;
  final Future<Note> Function(Note) onSave;
    final Label? initialLabel; 
  const AddEditNoteView(
      {super.key, this.note, required this.onSave, required this.getLabels, this.initialLabel});

  @override
  State<AddEditNoteView> createState() => _AddEditNoteViewState();
}

class _AddEditNoteViewState extends State<AddEditNoteView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _labelController;

  bool _isLoading = false;
  List<int> _selectedLabelIds = [];

  final labelsCubit = AwaitCubit<List<Label?>>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.details ?? '');
    _labelController = TextEditingController();


    _selectedLabelIds = List<int>.from(widget.note?.labelIds ?? <int>[]);
 if (widget.note == null && widget.initialLabel != null && widget.initialLabel!.id != null) {
      _selectedLabelIds.add(widget.initialLabel!.id!);
    }


    labelsCubit.load(widget.getLabels, null, inital: true);
  }

  Note get currentNote {
    return Note(
      id: widget.note?.id,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      updatedAt: widget.note != null ? DateTime.now() : null,
      title: _titleController.text,
      details: _descriptionController.text,
      labelIds: _selectedLabelIds,
    );
  }

  Future<void> _onSave(TextEditingController? autocompleteController) async {
    if (_isLoading) return;

    // 1. Don't save if everything is empty
    final text = autocompleteController?.text.trim() ?? '';
    if (_titleController.text.trim().isEmpty &&
        _descriptionController.text.trim().isEmpty &&
        _selectedLabelIds.isEmpty &&
        text.isEmpty) {
      if (mounted) Navigator.pop(context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Handle new label
      if (text.isNotEmpty) {
        final allLabels = await api.labels.list(null);

        final exists =
            allLabels.any((l) => l.name.toLowerCase() == text.toLowerCase());

        if (!exists) {
          final newLabel = await api.labels.insert(Label(name: text));
          if (!_selectedLabelIds.contains(newLabel.id)) {
            _selectedLabelIds.add(newLabel.id!);
          }
        }

        _labelController.clear();
      }

      // 3. Save note
      final updateNote = currentNote.copyWith(labelIds: _selectedLabelIds);
      final saveNote = await widget.onSave(updateNote);
      if (!mounted) return;

      Navigator.pop(context, saveNote);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //! Ensures that the keyboard pushes up content instead of overlapping it
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,

      //! Custom AppBar with back navigation and an extra options button
      appBar: HomeAppBar(
        title: '',
        leading: IconButton(
          onPressed: () async {
            // Await the save function fully
            await _onSave(_labelController);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0XFF646464),
          ),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, color: Color(0XFF646464)),
        ),
      ),

      //! Main body content
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //! Displays the last updated date of the note
                  if (widget.note != null)
                    Text(
                      widget.note?.updatedAt != null
                          ? 'Updated at ${DateFormat('dd MMM').format(widget.note!.updatedAt!)}'
                          : 'Created at ${DateFormat('dd MMM').format(widget.note?.createdAt ?? DateTime.now())}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  const SizedBox(height: 8),
                  //! Title input field
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Untitled',
                      hintStyle:
                          TextStyle(color: Color(0xFF9B9696), fontSize: 36),
                      border: InputBorder.none,
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  //! Expanded description text field
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                        hintStyle:
                            TextStyle(color: Color(0xFF9B9696), fontSize: 16),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),

                  const SizedBox(height: 12),
                  AwaitBuilder<List<Label?>>(
                    cubit: labelsCubit,
                    getData: widget.getLabels,
                    builder: (context, state) {
                      if (state.status == AwaitStatus.loading) {
                        return const SizedBox();
                      }

                      final labels = state.data ?? [];
                      final selectedLabels = labels
                          .where(
                              (label) => _selectedLabelIds.contains(label?.id))
                          .toList();

                      return Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: selectedLabels.map((label) {
                          if (label == null) return const SizedBox();
                          return Chip(
                            label: Text(label.name),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              setState(() {
                                _selectedLabelIds.remove(label.id);
                              });
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Autocomplete<Label>(
                          optionsViewOpenDirection: OptionsViewOpenDirection.up,
                          optionsViewBuilder: (context, onSelected, options) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 100,
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                elevation: 4,
                                color: Colors.white,
                                child: ListView.builder(
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final Label option =
                                          options.elementAt(index);
                                      return ListTile(
                                        title: Text(option.name),
                                        onTap: () {
                                          onSelected(option);
                                        },
                                      );
                                    }),
                              ),
                            );
                          },
                          optionsBuilder: (TextEditingValue value) async {
                            if (value.text.isEmpty)
                              return const Iterable<Label>.empty();

                            final labels = await api.labels.list(null);
                            final query = value.text.toLowerCase();

                            return labels.where(
                              (label) =>
                                  label.name.toLowerCase().contains(query),
                            );
                          },
                          displayStringForOption: (Label option) => option.name,
                          onSelected: (Label selected) {
                            setState(() {
                              if (!_selectedLabelIds.contains(selected.id)) {
                                _selectedLabelIds.add(selected.id!);
                              }
                              _labelController.clear();
                            });
                          },
                          fieldViewBuilder: (context, fieldContrller, focusNode,
                              onFieldSubmitted) {
                            return NoteTextField(
                              borderWidth: 0,
                              borderColor: Colors.transparent,
                              controller: fieldContrller,
                              focusNode: focusNode,
                              hintText: 'Type to add label',
                              onChanged: (v) => _labelController.text = v,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 0,
                              child: _circle(const Color(0XFF00A894)),
                            ),
                            Positioned(
                              right: 18,
                              child: _circle(const Color(0XFFFF7E56)),
                            ),
                            Positioned(
                              child: _circle(const Color(0XFF0081C8)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

// //! Helper function to draw a color circle option
Widget _circle(Color color) {
  return Container(
    width: 35,
    height: 35,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
  );
}

 

  // //! Predefined tag label
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: 8, vertical: 6),
  //                       decoration: BoxDecoration(
  //                         color: const Color(0XFFF4F4F5),
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: const Text(
  //                         'Office',
  //                         style: TextStyle(
  //                             fontSize: 14,
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.w500),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8),