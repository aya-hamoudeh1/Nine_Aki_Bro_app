import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/sizes.dart';
import '../../../../../core/helpers/helper_functions.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 150,
          image: AssetImage(
            dark
                ? 'assets/logos/logo_test.png'
                : 'assets/logos/logo_test_primary_color.png',
          ),
        ),
        Text(
          LocaleKeys.login_title.tr(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: dark ? Colors.white : TColors.primary,
          ),
        ),
        const SizedBox(height: TSizes.sm),
        Text(
          LocaleKeys.login_subtitle.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
