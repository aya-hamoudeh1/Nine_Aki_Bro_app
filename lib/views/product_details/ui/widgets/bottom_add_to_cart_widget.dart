import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/helpers/helper_functions.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/models/product_variants_model.dart';
import '../../../../core/widgets/icons/t_circular_icon.dart';
import '../../../cart/logic/cubit/cart_cubit/cart_cubit.dart';

class TBottomAddToCart extends StatelessWidget {
  const TBottomAddToCart({
    super.key,
    required this.product,
    this.selectedVariant,
  });

  final ProductModel product;
  final ProductVariantModel? selectedVariant;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final canAddToCart =
        selectedVariant != null && (selectedVariant?.stock ?? 0) > 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: dark ? TColors.darkerGrey : TColors.light,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(TSizes.cardRadiusLg),
          topLeft: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AnimatedCircularIcon(
                onPressed: () {},
                icon: Iconsax.minus,
                backgroundColor: TColors.darkerGrey,
                width: 40,
                height: 40,
                color: TColors.white,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(
                '1',
                style: Theme.of(context).textTheme.titleSmall,
              ), // Default to 1 for now
              const SizedBox(width: TSizes.spaceBtwItems),
              AnimatedCircularIcon(
                onPressed: () {},
                icon: Iconsax.add,
                backgroundColor: TColors.black,
                width: 40,
                height: 40,
                color: TColors.white,
              ),
            ],
          ),
          ElevatedButton(
            onPressed:
                canAddToCart
                    ? () {
                      // **[NEW LOGIC]** Call the cubit to add the item
                      context.read<CartCubit>().addToCart(
                        product,
                        selectedVariant!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(LocaleKeys.item_added_to_cart.tr()),
                          backgroundColor: TColors.primary,
                        ),
                      );
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(TSizes.md),
              backgroundColor: canAddToCart ? TColors.black : TColors.darkGrey,
              side: BorderSide(
                color: canAddToCart ? TColors.black : TColors.darkGrey,
              ),
            ),
            child: Text(LocaleKeys.add_to_cart.tr()),
          ),
        ],
      ),
    );
  }
}
