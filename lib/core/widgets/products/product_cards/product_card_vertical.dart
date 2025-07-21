import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../generated/local_keys.g.dart';
import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../helpers/helper_functions.dart';
import '../../../../views/product_details/ui/product_detail.dart';
import '../../../models/product_model.dart';
import '../../../styles/shadows.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../icons/t_circular_icon.dart';
import '../../images/t_rounded_image.dart';
import '../../texts/product_title_text.dart';
import '../../texts/t_brand_title_text_with_verified_icon.dart';
import '../../texts/t_product_price_text.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({
    super.key,
    required this.productModel,
    this.onPressed,
    required this.isFavorite,
    this.onAddToCart,
  });

  final Function()? onPressed;
  final bool isFavorite;
  final ProductModel productModel;
  final Function()? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final textDirection = Directionality.of(context);

    final String? displayImageUrl =
        productModel.imageUrl ??
        (productModel.variants.isNotEmpty
            ? productModel.variants.first.imageUrl
            : null);

    final String displayPrice =
        productModel.variants.isNotEmpty
            ? productModel.variants.first.price.toStringAsFixed(2)
            : productModel.price ?? '0';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetailScreen(productModel: productModel),
          ),
        );
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.grey,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  TRoundedImage(
                    width: double.infinity,
                    imageUrl:
                        displayImageUrl, // It now correctly passes a String?
                    applyImageRadius: true,
                    isNetworkImage: true,
                  ),
                  Positioned.directional(
                    textDirection: textDirection,
                    top: 12,
                    child: TRoundedContainer(
                      radius: TSizes.sm,
                      backgroundColor: TColors.secondary.withAlpha(204),
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm,
                        vertical: TSizes.xs,
                      ),
                      child: Text(
                        LocaleKeys.salePercentage.tr(
                          namedArgs: {'saleValue': productModel.sale ?? '0'},
                        ),
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.apply(color: TColors.black),
                      ),
                    ),
                  ),
                  Positioned.directional(
                    textDirection: textDirection,
                    top: 0,
                    end: 0,
                    child: AnimatedCircularIcon(
                      icon: Iconsax.heart5,
                      color: isFavorite ? Colors.red : TColors.darkGrey,
                      onPressed: onPressed,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TProductTitleText(
                    title:
                        productModel.productName ??
                        LocaleKeys.defaultProductName.tr(),
                    smallSize: true,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  TBrandTitleWithVerifiedIcon(
                    title: LocaleKeys.brandNameBro.tr(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: TSizes.sm),
                  child: TProductPriceText(price: displayPrice),
                ),
                GestureDetector(
                  onTap: onAddToCart,
                  child: Container(
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(TSizes.cardRadiusMd),
                        bottomEnd: Radius.circular(TSizes.productImageRadius),
                      ),
                    ),
                    child: const SizedBox(
                      width: TSizes.iconLg * 1.2,
                      height: TSizes.iconLg * 1.2,
                      child: Center(
                        child: Icon(Iconsax.add, color: TColors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
