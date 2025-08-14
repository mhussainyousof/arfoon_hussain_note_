import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class CategoryFilterChips extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;

  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final selected = index == selectedIndex;
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
                  categories[index],
                  style: TextStyle(
                      fontSize: 13,
                      color: selected ? Colors.white : const Color(0xFF71717A)),
                ),
                selected: selected,
                selectedColor: AppColors.chipSelected,
                onSelected: (_) {},
              ),
            );
          },
        ),
      ),
    );
  }
}
