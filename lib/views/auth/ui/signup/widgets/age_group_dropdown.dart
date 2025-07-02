import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';

class AgeGroupDropdown extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;

  const AgeGroupDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  static const ageGroups = ['13 - 17', '18 - 24', '25 - 34', '35 - 44', '45+'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: LocaleKeys.age.tr(),
        border: OutlineInputBorder(),
      ),
      value: selectedValue,
      items:
          ageGroups
              .map((age) => DropdownMenuItem(value: age, child: Text(age)))
              .toList(),
      onChanged: onChanged,
    );
  }
}
