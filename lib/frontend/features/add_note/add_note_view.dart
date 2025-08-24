import 'package:arfoon_note/frontend/features/home/widgets/home_appbar.dart';
import 'package:arfoon_note/frontend/widgets/widget.dart';
import 'package:arfoon_note/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../client/client.dart';
import '../../theme/theme.dart';

class AddNoteView extends StatefulWidget {
  final Note? note;

  final Future<Note> Function(Note) onSave;
  const AddNoteView({super.key, this.note, required this.onSave});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _labelController;
  bool _isLoading = false;
  List<int> _selectedLabelIds = [];


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.details ?? '');
    _labelController = TextEditingController();
    _selectedLabelIds = List<int>.from(widget.note?.labelIds ?? <int>[]);
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

  Future<void> _onSave() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final saveNote = await widget.onSave(currentNote);
      
      Navigator.pop(context, saveNote);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Some thing went wrong')));
    } finally { 
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
          onPressed: _onSave,

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
                  Wrap(
                      spacing: 6,
                      children: _selectedLabelIds
                          .map((id) => FutureBuilder<Label?>(
                                future: api.labels.get(id),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData){
                                    return const SizedBox();
                                  }
                                  return Chip(
                                    label: Text(snapshot.data!.name),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedLabelIds.remove(id);
                                      });
                                    },
                                  );
                                },
                              ))
                          .toList()),

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
                            });
                          },
                          fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSubmitted) {
                            return NoteTextField(
                              borderWidth: 0,
                              borderColor: Colors.transparent,
                              controller: textEditingController,
                              focusNode: focusNode,
                              hintText: 'Type to add label',
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