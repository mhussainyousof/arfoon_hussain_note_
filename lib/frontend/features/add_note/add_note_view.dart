import 'package:arfoon_note/frontend/features/home/widgets/home_appbar.dart';
import 'package:arfoon_note/integration/blocs/note/note_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../client/client.dart';
import '../../theme/theme.dart';

class AddNoteView extends StatefulWidget {
  final Note? note;

  final Future<Note> Function(Note?) onSave;
  const AddNoteView({super.key, this.note, required this.onSave});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _labelController;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.details ?? '');
    _labelController = TextEditingController();
  }

  Note get currentNote {
    return Note(
      id: widget.note?.id,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      updatedAt: widget.note != null ? DateTime.now() : null,
      title: _titleController.text,
      details: _descriptionController.text,
      labelIds: [],
    );
  }

  Future<void> _onSave() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSave(currentNote);
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
      body:
      
       SafeArea(
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
                      hintStyle: TextStyle(color: Color(0xFF9B9696), fontSize: 36),
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
            
                  //! Tag and color selection section
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          //! Field for adding a new tag
                          const Expanded(
                            child: TextField(
                              // controller: _labelController,
                              decoration: InputDecoration(
                                hintText: 'Add Label',
                                hintStyle: TextStyle(fontSize: 14),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
            
                          //! Color selection palette
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
                    ),
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

//! Helper function to draw a color circle option
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