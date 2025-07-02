import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../core/constants/colors.dart';
import '../../auth/ui/login/login_view.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return Positioned.directional(
      textDirection: textDirection,
      top: 40,
      end: 20,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        child: Text(
          LocaleKeys.skip.tr(),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: TColors.primary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
