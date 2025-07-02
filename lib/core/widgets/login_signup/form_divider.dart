import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../constants/colors.dart';
import '../../helpers/helper_functions.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(
          child: Divider(
            color: TColors.darkGrey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(
          LocaleKeys.or_sign_in_with.tr(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: dark ? Colors.white : TColors.primary,
          ),
        ),
        const Flexible(
          child: Divider(
            color: TColors.darkGrey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        ),
      ],
    );
  }
}
