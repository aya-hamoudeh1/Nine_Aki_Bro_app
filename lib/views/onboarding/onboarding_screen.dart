import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/onboarding/widgets/dot_navigation.dart';
import 'package:nine_aki_bro_app/views/onboarding/widgets/next_button.dart';
import 'package:nine_aki_bro_app/views/onboarding/widgets/onboarding_page.dart';
import 'package:nine_aki_bro_app/views/onboarding/widgets/skip_button.dart';
import 'cubit/onboarding_cubit.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<OnBoardingCubit>();
          return Scaffold(
            body: Stack(
              children: [
                /// Horizontal Scrollable pages
                PageView(
                  controller: cubit.pageController,
                  onPageChanged: (index) {
                    cubit.goToPage(index);
                  },
                  children: [
                    OnBoardingPage(
                      image: 'assets/images/onboarding/onboarding1.png',
                      title: LocaleKeys.onboarding_title_1.tr(),
                      subTitle: LocaleKeys.onboarding_subtitle_1.tr(),
                    ),
                    OnBoardingPage(
                      image: 'assets/images/onboarding/onboarding2.jpg',
                      title: LocaleKeys.onboarding_title_2.tr(),
                      subTitle: LocaleKeys.onboarding_subtitle_2.tr(),
                    ),
                    OnBoardingPage(
                      image: 'assets/images/onboarding/onboarding3.jpg',
                      title: LocaleKeys.onboarding_title_3.tr(),
                      subTitle: LocaleKeys.onboarding_subtitle_3.tr(),
                    ),
                  ],
                ),

                /// Skip Button
                const OnBoardingSkip(),

                /// Dot Navigation SmoothPageIndicator
                const OnBoardingDotNavigation(),

                /// Circular Button
                const OnBoardingNextButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
