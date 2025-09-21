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
    return Container(
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: ListView.builder(

        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final selected = (index == selectedIndex ) ? true : false;
        final label = chips[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
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
    );
  }
}
