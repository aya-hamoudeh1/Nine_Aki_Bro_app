import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../core/constants/colors.dart';
import '../../core/helpers/helper_functions.dart';
import '../../core/widgets/appbar/appbar.dart';
import '../../core/widgets/icons/t_circular_icon.dart';
import '../../core/widgets/layouts/grid_layout.dart';
import '../../core/widgets/products/product_cards/product_card_vertical.dart';
import '../../core/constants/sizes.dart';
import '../home/logic/home_cubit/home_cubit.dart';
import '../nav_bar/ui/navigation_menu.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final homeCubit = context.read<HomeCubit>();
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TAppBar(
                title: Text(
                  LocaleKeys.wishlist.tr(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: dark ? TColors.white : TColors.primary,
                  ),
                ),
                actions: [
                  AnimatedCircularIcon(
                    icon: Iconsax.add,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigationMenu(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final favoriteProducts =
                      context.read<HomeCubit>().favoriteProductList;
                  return TGridLayout(
                    itemCount: favoriteProducts.length,
                    itemBuilder:
                        (_, index) => TProductCardVertical(
                          productModel: favoriteProducts[index],
                          isFavorite: homeCubit.checkIsFavorite(
                            favoriteProducts[index].productId!,
                          ),
                          onPressed: () {
                            bool isFav = homeCubit.checkIsFavorite(
                              favoriteProducts[index].productId!,
                            );
                            isFav
                                ? homeCubit.removeFromFavorite(
                                  favoriteProducts[index].productId!,
                                )
                                : homeCubit.addToFavorite(
                                  favoriteProducts[index].productId!,
                                );
                          },
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
