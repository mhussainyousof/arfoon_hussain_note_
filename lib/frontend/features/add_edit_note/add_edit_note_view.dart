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
      {super.key,
      this.note,
      required this.onSave,
      required this.getLabels,
      this.initialLabel});

  @override
  State<AddEditNoteView> createState() => _AddEditNoteViewState();
}

class _AddEditNoteViewState extends State<AddEditNoteView> {
  // Text controllers for form fields8
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _labelController;

  final labelsCubit = AwaitCubit<List<Label?>>();

  // State variables
  final List<int> _selectedLabelIds = [];
  bool _isLoading = false;
  bool _isColorExpanded = false;
  int? _selectedColorId; // Currently selected color ID

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeSelections(); // Initialize selected labels and color
    _loadLabels(); // Load available labels
  }

// Initialize text controllers
  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.details ?? '');
    _labelController = TextEditingController();
  }

  // Initialize selected labels and color
  void _initializeSelections() {
    _selectedLabelIds.addAll(widget.note?.labelIds ?? []);
    if (widget.note == null && widget.initialLabel?.id != null) {
      _selectedLabelIds.add(widget.initialLabel!.id!);
    }
    _selectedColorId = widget.note?.colorId;
  }

  //Load labels using the cubit's load method

  void _loadLabels() => labelsCubit.load(widget.getLabels, null, inital: true);

  // Toggle the expanded state of the color selector
  void _toggleColorExpansion() =>
      setState(() => _isColorExpanded = !_isColorExpanded);

  void _selectColor(int? colorIndex) => setState(() {
        _selectedColorId = colorIndex;
        _isColorExpanded = false;
      });

  Note get currentNote {
    return Note(
        id: widget.note?.id,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        updatedAt: widget.note != null ? DateTime.now() : null,
        title: _titleController.text,
        details: _descriptionController.text,
        labelIds: _selectedLabelIds,
        colorId: _selectedColorId);
  }

// Check if the note is empty (no content, labels, or title)
  bool get _isEmptyNote {
    return _titleController.text.trim().isEmpty &&
        _descriptionController.text.trim().isEmpty &&
        _selectedLabelIds.isEmpty &&
        _labelController.text.trim().isEmpty;
  }

  // Save the note, handling new label creation
  Future<void> _onSave() async {
    if (_isLoading) return;

    if (_isEmptyNote) {
      if (mounted) Navigator.pop(context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _handleNewLabelCreation(); // Create new label if needed
      await _saveNote(); // Save the note
    } catch (e) {
      _showErrorSnackbar();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Handle creation of a new label from the label input field
  Future<void> _handleNewLabelCreation() async {
    final text = _labelController.text.trim();
    if (text.isEmpty) return;

    // Check if label already exists
    final allLabels = await api.noteServer.labels.list(null);
    final exists =
        allLabels.any((l) => l.name.toLowerCase() == text.toLowerCase());

    // Create new label if it doesn't exist
    if (!exists) {
      final newLabel = await api.noteServer.labels.insert(Label(name: text));
      if (newLabel.id != null && !_selectedLabelIds.contains(newLabel.id)) {
        _selectedLabelIds.add(newLabel.id!);
      }
    }

    _labelController.clear();
  }

  // Save the note using the provided onSave callback
  Future<void> _saveNote() async {
    final updatedNote = currentNote.copyWith(labelIds: _selectedLabelIds);
    final savedNote = await widget.onSave(updatedNote);

    if (!mounted) return;
    Navigator.pop(context, savedNote);
  }

  void _showErrorSnackbar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
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
      // keyboard pushes up content instead of overlapping it
      resizeToAvoidBottomInset: true,

      appBar: HomeAppBar(
        title: '',
        leading: IconButton(
          onPressed: _onSave,
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
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
                  CustomeTextField(
                    controller: _titleController,
                    hintText: 'Untitled',
                    hintSize: 36,
                    
                    hasBorder: false,
                    fontWeight: FontWeight.bold,
                  ),

                  //! Expanded description text field
                  Expanded(
                    child: CustomeTextField(
                      controller: _descriptionController,
                      hintText: 'Description',
                      hasBorder: false,
                      isMultiline: true,
                      maxLines: null,
                    ),
                  ),
                  //selected labels display using chips
                  AwaitBuilder<List<Label?>>(
                    cubit: labelsCubit,
                    getData: widget.getLabels,
                    builder: (context, state) {
                      if (state.status == AwaitStatus.loading) {
                        return const SizedBox();
                      }

                      final labels = state.data ?? [];

                      // Filter to only selected labels
                      final selectedLabels = labels
                          .where(
                              (label) => _selectedLabelIds.contains(label?.id))
                          .toList();

                      // Display selected labels as chips
                      return Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: selectedLabels.map((label) {
                          if (label == null) return const SizedBox();
                          return NoteChip(
                              text: label.name,
                              onDeleted: () => setState(() {
                                    _selectedLabelIds.remove(label.id);
                                  }));
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
                            if (value.text.isEmpty) {
                              return const Iterable<Label>.empty();
                            }

                            final labels = await api.noteServer.labels.list(null);
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
                            return CustomeTextField(
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
                      GestureDetector(
                        onTap: _toggleColorExpansion,
                        child: SizedBox(
                          width: _isColorExpanded ? 150 : 80,
                          height: 35,
                          child: Stack(
                            children: [
                              //!
                              // when user see first of note colors
                              //!
                              if (_selectedColorId == null &&
                                  !_isColorExpanded) ...[
                                _buildColorCircle(0, 0),
                                _buildColorCircle(1, 15),
                                _buildColorCircle(2, 30),
                              ],

                              //! when user click on colors to pick one
                              if (_isColorExpanded) ...[
                                _buildSelectableColor(0, 70),
                                _buildSelectableColor(1, 35),
                                _buildSelectableColor(2, 0),
                                Positioned(
                                  right: 105,
                                  top: 2.5,
                                  child: GestureDetector(
                                    onTap: () => _selectColor(null),
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close,
                                          size: 18, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],

                              //! when user picks one color
                              if (_selectedColorId != null && !_isColorExpanded)
                                _buildColorCircle(_selectedColorId!, 0,
                                    isSelected: true)
                            ],
                          ),
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

  Widget _buildSelectableColor(int colorIndex, double rightSpace) {
    return Positioned(
        right: rightSpace,
        child: GestureDetector(
          onTap: () => _selectColor(colorIndex),
          child: _buildColorCircle(colorIndex, rightSpace,
              isSelected: _selectedColorId == colorIndex),
        ));
  }
}

Widget _buildColorCircle(int colorIndex, double rightSpace,
    {bool isSelected = false}) {
  return Positioned(
      right: rightSpace,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.noteColors[colorIndex],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: isSelected ? 2 : 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      blurRadius: 3, color: AppColors.noteColors[colorIndex])
                ]
              : null,
        ),
      ));
}
