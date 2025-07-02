import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';

class SkinToneSelector extends StatelessWidget {
  final Function(Color selectedColor) onColorSelected;
  final Color? selectedColor;

  const SkinToneSelector(
      {super.key, required this.onColorSelected, this.selectedColor});

  final List<Color> skinTones = const [
    Color(0xFFFFDBAC), // Very light
    Color(0xFFF1C27D), // Light
    Color(0xFFE0AC69), // Medium
    Color(0xFFC68642), // Tan
    Color(0xFF8D5524), // Dark
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: skinTones.map((tone) {
        final isSelected = selectedColor == tone;
        return GestureDetector(
          onTap: () => onColorSelected(tone),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: tone,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: TColors.primary, width: 3)
                  : null,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
