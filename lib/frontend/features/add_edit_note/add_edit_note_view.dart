import 'package:arfoon_note/frontend/features/home/widgets/home_appbar.dart';
import 'package:arfoon_note/frontend/frontend.dart';
import 'package:arfoon_note/frontend/theme/responsive.dart';
import 'package:arfoon_note/integration/integration.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import '../../../client/client.dart';
import '../../theme/theme.dart';

class AddEditNoteView extends StatefulWidget {
  final Note? note;
  final Future<List<Label>> Function(Filter?) getLabels;
  final Future<Note> Function(Note) onSave;
  final Label? initialLabel;
  final AwaitCubit<List<Note>>? noteCubit;

  const AddEditNoteView({
    super.key,
    this.note,
    required this.onSave,
    required this.getLabels,
    this.initialLabel,
    this.noteCubit,
  });

  @override
  State<AddEditNoteView> createState() => _AddEditNoteViewState();
}

class _AddEditNoteViewState extends State<AddEditNoteView> {
  // ----------------------------
  // Controllers
  // ----------------------------
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TextEditingController _labelController;

  //! Cubit
  late final AwaitCubit<List<Label?>> labelCubit;

  // ----------------------------
  // State Variables
  // ----------------------------
  final List<int> _selectedLabelIds = [];
  bool _isLoading = false;
  bool _isColorExpanded = false;
  int? _selectedColorId; // Currently selected color ID
  Note? _note;

  @override
  void initState() {
    super.initState();
    labelCubit = AwaitCubit<List<Label>>();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _labelController = TextEditingController();

    setupNoteState();
    _loadLabels(); // Load available labels
  }

  @override
  void didUpdateWidget(AddEditNoteView oldWidget) {
    super.didUpdateWidget(oldWidget);
    //!
    // If the note prop changed, update the internal state
    if (widget.note != oldWidget.note) {
      _note = widget.note;
      setupNoteState(widget.note);
      _loadLabels();
    }
  }

  //!
  // setupNoteState
  void setupNoteState([Note? note]) {
    _note = note ?? widget.note;

    _titleController.text = _note?.title ?? '';
    _descriptionController.text = _note?.details ?? '';
    _labelController.text = '';

    _selectedLabelIds
      ..clear()
      ..addAll(_note?.labelIds ?? []);

    if (_note == null && widget.initialLabel?.id != null) {
      _selectedLabelIds.add(widget.initialLabel!.id!);
    }

    _selectedColorId = _note?.colorId;
  }

  //!
  //Load labels using the cubit's load method
  void _loadLabels() => labelCubit.load(widget.getLabels, null);
  //!
  // Toggle the expanded state of the color selector
  void _toggleColorPicker() =>
      setState(() => _isColorExpanded = !_isColorExpanded);

  void _selectColor(int? colorIndex) => setState(() {
        _selectedColorId = colorIndex;
        _isColorExpanded = false;
      });

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _labelController.clear();
    _selectedLabelIds.clear();
    _selectedColorId = null;
    _note = null;
    //!
    // If there's an initial label, add it back
    if (widget.initialLabel?.id != null) {
      _selectedLabelIds.add(widget.initialLabel!.id!);
    }

    setState(() {});
  }

  Note get currentNote {
    return Note(
        id: _note?.id,
        createdAt: _note?.createdAt ?? DateTime.now(),
        updatedAt: _note != null ? DateTime.now() : null,
        title: _titleController.text,
        details: _descriptionController.text,
        labelIds: _selectedLabelIds,
        colorId: _selectedColorId);
  }

  //!
  // Check if the note is empty (no content, labels, or title)
  bool get _isEmptyNote {
    return _titleController.text.trim().isEmpty &&
        _descriptionController.text.trim().isEmpty &&
        _selectedLabelIds.isEmpty &&
        _labelController.text.trim().isEmpty;
  }

  //!
  // Save the note, handling new label creation
  Future<void> _handleSave() async {
    if (_isLoading) return;

    if (_isEmptyNote) {
      if (!Responsive.isDesktop(context) && mounted) Navigator.pop(context);
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

  //!
  // Handle creation of a new label from the label input field
  Future<void> _handleNewLabelCreation() async {
    final text = _labelController.text.trim();
    if (text.isEmpty) return;
    //!
    // Check if label already exists
    final allLabels = await api.noteServer.labels.list(null);
    final exists =
        allLabels.any((l) => l.name.toLowerCase() == text.toLowerCase());
    //!
    // Create new label if it doesn't exist
    if (!exists) {
      final newLabel = await api.noteServer.labels.insert(Label(name: text));
      if (newLabel.id != null && !_selectedLabelIds.contains(newLabel.id)) {
        _selectedLabelIds.add(newLabel.id!);
      }
      labelCubit.refresh();
    }
  }

  //!
  // Save the note using the provided onSave callback
  Future<void> _saveNote() async {
    final updatedNote = currentNote.copyWith(labelIds: _selectedLabelIds);
    final savedNote = await widget.onSave(updatedNote);
    if (!mounted) return;
    if (!Responsive.isDesktop(context) && mounted) {
      Navigator.pop(context, savedNote);
    } else {
      _resetForm();
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: HomeAppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey[300],
              height: 1.0,
            ),
          ),
          centerTitle: false,
          isLocalTitle: false,
          title: _note != null && isDesktop
              ? '${Locales.string(context, 'my_notes')} > ${_note!.title}'
              : !isDesktop
                  ? ''
                  : Locales.string(context, 'my_notes'),
          titleSize: 14,
          titleFontWeight: FontWeight.bold,
          leading: isDesktop
              ? null
              : IconButton(
                  onPressed: _handleSave,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Row(
              children: [
                //!
                // update time for desktop
                if (isDesktop && _note != null)
                  _buildNoteDate(context, widget.note?.createdAt, widget.note?.updatedAt),
                const SizedBox(width: 20),

                //!
                // Create and Update note button for desktop
                if (isDesktop)
                  TextButton(
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(7))),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.black),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.grey[100])),
                      onPressed: _handleSave,
                      child: Row(
                        children: [
                          const Icon(Icons.save_as_outlined),
                          const SizedBox(
                            width: 5,
                          ),
                          LocaleText(
                              _note != null ? 'save_changes' : 'create_note'),
                        ],
                      )),

                //!
                // Delete Note button
                if (!_isEmptyNote && _note != null)
                  IconButton(
                    onPressed: () async {
                      SureView(
                          title: 'delete',
                          subTitle: 'confirm_delete',
                          sureText: 'delete',
                          onSure: () async {
                            await api.noteServer.notes
                                .deleteNote(widget.note!.id!);
                            if (!isDesktop) {
                              Navigator.pop(
                                context,
                              );
                            } else {
                              _resetForm();
                            }
                            await widget.noteCubit!.refresh();
                            await labelCubit.refresh();
                          }).show(context);
                    },
                    icon: const Icon(Icons.delete),
                  ),
              ],
            ),
          ),
        ),

        //!
        //Main body content
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //!
                  // Displays the last updated date of the note
                  if (!isDesktop && widget.note != null)
                    
                     _buildNoteDate(context, widget.note?.createdAt, widget.note?.updatedAt),
                    
                  const SizedBox(height: 8),
                  //!
                  // Title input field
                  CustomeTextField(
                    controller: _titleController,
                    hintText: 'untitled',
                    hintSize: 36,
                    hasBorder: false,
                    fontWeight: FontWeight.bold,
                  ),

                  //!
                  // description text field
                  Expanded(
                    child: CustomeTextField(
                      controller: _descriptionController,
                      hintText: 'description',
                      hasBorder: false,
                      isMultiline: true,
                      maxLines: null,
                    ),
                  ),
                  //!
                  //selected labels display using chips
                  AwaitBuilder<List<Label?>>(
                    cubit: labelCubit,
                    getData: widget.getLabels,
                    builder: (context, state) {
                      if (state.status == AwaitStatus.loading) {
                        return const SizedBox();
                      }

                      final labels = state.data ?? [];
                      //!
                      // Filter to only selected labels
                      final selectedLabels = labels
                          .where(
                              (label) => _selectedLabelIds.contains(label?.id))
                          .toList();
                      //!
                      // Display selected labels as chips
                      return Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: selectedLabels.map((label) {
                          return NoteChip(
                            text: label!.name,
                            onDeleted: () => setState(() {
                              _selectedLabelIds.remove(label.id);
                            }),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        //!
                        // Label input with autocomplete
                        child: Autocomplete<Label>(
                          optionsViewOpenDirection: OptionsViewOpenDirection.up,
                          optionsViewBuilder: (context, onSelected, options) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 150,
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(12),
                                elevation: 4,
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

                            final labels =
                                await api.noteServer.labels.list(null);
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
                            _labelController = fieldContrller;
                            return CustomeTextField(
                              borderWidth: 0,
                              borderColor: Colors.transparent,
                              controller: fieldContrller,
                              focusNode: focusNode,
                              hintText: 'type_to_add_label',
                            );
                          },
                        ),
                      ),
                      isDesktop
                          ? Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: SizedBox(
                                width: 150,
                                height: 35,
                                child: Stack(
                                  children: [
                                    if (!_isColorExpanded) ...[
                                      Positioned(
                                        right: isRTL(context) ? 55 : 70,
                                        child: GestureDetector(
                                          onTap: () => _selectColor(0),
                                          child: _buildColorCircle(0, 0,
                                              isSelected:
                                                  _selectedColorId == 0),
                                        ),
                                      ),
                                      Positioned(
                                        right: isRTL(context) ? 88 : 35,
                                        child: GestureDetector(
                                          onTap: () => _selectColor(1),
                                          child: _buildColorCircle(1, 0,
                                              isSelected:
                                                  _selectedColorId == 1),
                                        ),
                                      ),
                                      Positioned(
                                        right: isRTL(context) ? 120 : 0,
                                        child: GestureDetector(
                                          onTap: () => _selectColor(2),
                                          child: _buildColorCircle(2, 0,
                                              isSelected:
                                                  _selectedColorId == 2),
                                        ),
                                      ),
                                    ],
                                    if (_selectedColorId != null)
                                      Positioned(
                                        right: isRTL(context) ? 25 : 105,
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
                                ),
                              ),
                            )
                          :

                          //!
                          // Mobile version continues...
                          GestureDetector(
                              onTap: _toggleColorPicker,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: SizedBox(
                                  width: _isColorExpanded ? 150 : 60,
                                  height: 35,
                                  child: Stack(
                                    children: [
                                      // When user sees first of note colors
                                      if (_selectedColorId == null &&
                                          !_isColorExpanded) ...[
                                        Positioned(
                                            right: 0,
                                            child: _buildColorCircle(0, 0)),
                                        Positioned(
                                            right: 15,
                                            child: _buildColorCircle(1, 0)),
                                        Positioned(
                                            right: 30,
                                            child: _buildColorCircle(2, 0)),
                                      ],

                                      // When user clicks on colors to pick one
                                      if (_isColorExpanded) ...[
                                        Positioned(
                                          right: isRTL(context) ? 55 : 70,
                                          child: GestureDetector(
                                            onTap: () => _selectColor(2),
                                            child: _buildColorCircle(2, 0,
                                                isSelected:
                                                    _selectedColorId == 2),
                                          ),
                                        ),
                                        Positioned(
                                          right: isRTL(context) ? 88 : 35,
                                          child: GestureDetector(
                                            onTap: () => _selectColor(1),
                                            child: _buildColorCircle(1, 0,
                                                isSelected:
                                                    _selectedColorId == 1),
                                          ),
                                        ),
                                        Positioned(
                                          right: isRTL(context) ? 120 : 0,
                                          child: GestureDetector(
                                            onTap: () => _selectColor(0),
                                            child: _buildColorCircle(0, 0,
                                                isSelected:
                                                    _selectedColorId == 0),
                                          ),
                                        ),
                                        Positioned(
                                          right: isRTL(context) ? 25 : 105,
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

                                      // When user picks one color
                                      if (_selectedColorId != null &&
                                          !_isColorExpanded)
                                        Positioned(
                                          right: isRTL(context) ? 30 : 0,
                                          child: _buildColorCircle(
                                              _selectedColorId!, 0,
                                              isSelected: true),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            )
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

Widget _buildColorCircle(int colorIndex, double rightSpace,
    {bool isSelected = false}) {
  return Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      color: AppColors.noteColors[colorIndex],
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: isSelected ? 2 : 1),
      boxShadow: isSelected
          ? [BoxShadow(blurRadius: 3, color: AppColors.noteColors[colorIndex])]
          : null,
    ),
  );
}

Widget _buildNoteDate(BuildContext context, DateTime? createdAt, DateTime? updatedAt){
  final date = updatedAt ?? createdAt ?? DateTime.now();
  final isUpdated = updatedAt != null;
  final locale = Locales.currentLocale(context)?.languageCode;
  String formattedDate;
  if(locale == 'fa' || locale == 'ps'){
    formattedDate = DateFormat('d MMMM', 'fa').format(date);
  }else{
    formattedDate = DateFormat('dd MMM').format(date);
  }

  return Text(
    '${Locales.string(context, isUpdated ? 'updated_at' : 'created_at')} $formattedDate',
     style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey,
          fontSize: 11,
        ),
  );
}
