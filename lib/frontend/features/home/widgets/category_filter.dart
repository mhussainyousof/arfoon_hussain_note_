import 'package:flutter/material.dart';
import 'package:arfoon_note/client/models/models.dart';
import 'package:flutter_locales/flutter_locales.dart';

class CategoryFilterChips extends StatelessWidget {
  final List<Label> labels;
  final int selectedIndex;

  final void Function(Label) onSelectLabel;

  const CategoryFilterChips({
    super.key,
    required this.labels,
    required this.selectedIndex, required this.onSelectLabel,
  });

  @override
  Widget build(BuildContext context) {
    final chips = [Label(name: Locales.string(context, 'all_notes'), id: null),...labels];
    return SizedBox(
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          itemBuilder: (context, index) {
            final selected = (index == selectedIndex ) ? true : false;
          final label = chips[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                showCheckmark: false,
                label: Text(
                  label.name,
                ),
                selected: selected,
                onSelected: (_) => onSelectLabel(label)
              ),
            );
          },
        ),
      ),
    );
  }
}
