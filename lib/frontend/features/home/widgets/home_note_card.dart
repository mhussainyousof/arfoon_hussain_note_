import 'package:flutter/material.dart';
import '../../../../theme/theme.dart';

class NoteCardData {
  final String date;
  final String title;
  final String description;
  final List<String> tags;
  final bool isPinned;
  final bool isHighlighted;

  NoteCardData({
    required this.date,
    required this.title,
    required this.description,
    required this.tags,
    this.isPinned = false,
    this.isHighlighted = false,
  });
}

class NoteCard extends StatelessWidget {
  final NoteCardData data;

  const NoteCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bgColor =
        data.isHighlighted ? AppColors.primaryBlue : AppColors.background;
    final textColor = data.isHighlighted ? Colors.white : Colors.black;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.date,
                  style: TextStyle(
                     color: data.isPinned
                          ? Colors.white
                          : const Color(0XFF919191)
                  )),
              const SizedBox(height: 8),
              Text(data.title,
                  style: TextStyle(color: textColor)),
              const SizedBox(height: 6),
              Text(
                data.description,
                style: TextStyle(
                  color:
                        data.isPinned ? Colors.white : const Color(0XFFA2A2A2)
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 6,
                children: data.tags
                    .map((tag) => Chip(
                        backgroundColor:
                            const Color.fromARGB(255, 253, 253, 254),
                        side: const BorderSide(color: Color(0xFFE4E4E7)),
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 3),
                        label: Text(
                          tag,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0XFFA2A2A2),
                              fontWeight: FontWeight.w500),
                        )))
                    .toList(),
              ),
            ],
          ),
        ),
        Positioned(
            top: 16,
            right: 20,
            child: Card(
              elevation: 0.1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: data.isPinned ? Colors.black : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Image.asset(
                  data.isPinned
                      ? 'assets/images/card_pin_tag.png'
                      : 'assets/images/card_pin.png',
                  width: 14,
                  height: 14,
                      
                ),
              ),
            )),
      ],
    );
  }
}
