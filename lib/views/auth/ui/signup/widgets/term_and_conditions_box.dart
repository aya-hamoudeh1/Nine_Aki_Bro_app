import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/sizes.dart';
import '../../../../../core/helpers/helper_functions.dart';
import '../../../../../generated/local_keys.g.dart';

class TTermAndConditionsBox extends StatelessWidget {
  const TTermAndConditionsBox({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Checkbox(value: true, onChanged: (value) {}),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.i_agree_to.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: LocaleKeys.privacy_policy.tr(),
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: LocaleKeys.and.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: LocaleKeys.terms_of_use.tr(),
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
