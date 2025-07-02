import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../core/constants/colors.dart';
import '../../home/ui/home_view.dart';
import '../../settings/settings.dart';
import '../../store/store.dart';
import '../../wishlist/wishlist.dart';
import '../logic/navigation_cubit.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: _getPage(selectedIndex),
            bottomNavigationBar: Container(
              color: TColors.primary,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8,
                ),
                child: GNav(
                  rippleColor: TColors.primary,
                  hoverColor: TColors.primary,
                  curve: Curves.easeInOutExpo,
                  duration: const Duration(milliseconds: 400),
                  gap: 4,
                  color: TColors.grey,
                  activeColor: Colors.white,
                  tabBackgroundColor: TColors.darkerGrey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  selectedIndex: selectedIndex,
                  onTabChange: (index) {
                    context.read<NavigationCubit>().changeTab(index);
                  },
                  tabs: [
                    GButton(icon: Iconsax.home, text: LocaleKeys.home.tr()),
                    GButton(icon: Iconsax.shop, text: LocaleKeys.store.tr()),
                    GButton(
                      icon: Iconsax.heart,
                      text: LocaleKeys.wishlist.tr(),
                    ),
                    GButton(icon: Iconsax.user, text: LocaleKeys.profile.tr()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _getPage(int index) {
  switch (index) {
    case 0:
      return const HomeView();
    case 1:
      return const StoreScreen();
    case 2:
      return const FavoriteScreen();
    case 3:
      return const SettingScreen();
    default:
      return const HomeView();
  }
}
