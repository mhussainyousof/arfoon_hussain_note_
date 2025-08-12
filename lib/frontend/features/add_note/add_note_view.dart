// lib/frontend/features/note_detail/note_detail_view.dart
import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class AddNoteView extends StatelessWidget {
  final String updatedAt;
  final String title;
  final String description;
  final List<String> labels;
  final List<Color> availableColors;
  final Color selectedColor;

  final VoidCallback onBack;
  final VoidCallback onMore;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<String> onAddLabel;

  const AddNoteView({
    super.key,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.labels,
    required this.availableColors,
    required this.selectedColor,
    required this.onBack,
    required this.onMore,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onColorSelected,
    required this.onAddLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: onMore,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Updated at $updatedAt',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Untitled',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              controller: TextEditingController(text: title),
              onChanged: onTitleChanged,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Description',
                border: InputBorder.none,
              ),
              maxLines: null,
              controller: TextEditingController(text: description),
              onChanged: onDescriptionChanged,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final label in labels)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(label: Text(label)),
                    ),
                  GestureDetector(
                    onTap: () => onAddLabel('New Label'),
                    child: Chip(
                      label: const Text('Add Label'),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final color in availableColors)
                  GestureDetector(
                    onTap: () => onColorSelected(color),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color == selectedColor
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
