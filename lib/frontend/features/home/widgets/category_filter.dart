import 'package:flutter/material.dart';
import 'package:arfoon_note/client/models/models.dart';
import 'package:arfoon_note/frontend/theme/theme.dart';

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

    final chips = [Label(name: "All Notes", id: null),...labels];


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
            final selected = index == selectedIndex;
          final label = chips[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                showCheckmark: false,
                side: const BorderSide(color: Color(0XFFE4E4E7)),
                backgroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                label: Text(
                  label.name,
                  style: TextStyle(
                      fontSize: 13,
                      color: selected ? Colors.white : const Color(0xFF71717A)),
                ),
                selected: selected,
                selectedColor: AppColors.chipSelected,
                onSelected: (_) => onSelectLabel(label)
              ),
            );
          },
        ),
      ),
    );
  }
}
