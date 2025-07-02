import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/colors.dart';
import '../cubit/onboarding_cubit.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final cubit = context.read<OnBoardingCubit>();

    return Positioned.directional(
      textDirection: textDirection,
      bottom: 40,
      start: 20,
      child: BlocBuilder<OnBoardingCubit, int>(
        builder: (context, pageIndex) {
          return SmoothPageIndicator(
            effect: const ExpandingDotsEffect(
              activeDotColor: TColors.primary,
              dotHeight: 6,
            ),
            controller: cubit.pageController,
            count: 3,
            onDotClicked: (index) {
              cubit.goToPage(index);
            },
          );
        },
      ),
    );
  }
}
