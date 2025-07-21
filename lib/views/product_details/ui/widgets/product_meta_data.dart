import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/models/product_variants_model.dart';
import '../../../../core/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../core/widgets/images/t_circular_image.dart';
import '../../../../core/widgets/texts/product_title_text.dart';
import '../../../../core/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import '../../../../core/widgets/texts/t_product_price_text.dart';

class TProductMetaData extends StatelessWidget {
  const TProductMetaData({
    super.key,
    required this.product,
    this.selectedVariant,
  });

  final ProductModel product;
  final ProductVariantModel? selectedVariant;

  @override
  Widget build(BuildContext context) {
    // Determine which price and sale info to show
    final displayPrice =
        selectedVariant?.price.toStringAsFixed(2) ?? product.price ?? '0';
    final originalPrice =
        product.oldPrice ??
        (double.tryParse(product.price ?? '0') ?? 0 * 1.25).toStringAsFixed(2);
    final salePercentage = product.sale ?? '0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Price
        Row(
          children: [
            /// Sale Tag
            TRoundedContainer(
              radius: TSizes.sm,
              backgroundColor: TColors.secondary.withAlpha(204),
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.sm,
                vertical: TSizes.xs,
              ),
              child: Text(
                '$salePercentage%',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.apply(color: TColors.black),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),

            /// Original Price
            Text(
              '\$$originalPrice',
              style: Theme.of(context).textTheme.titleSmall!.apply(
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),

            /// Display Price (Variant or Main)
            TProductPriceText(price: displayPrice, isLarge: true),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        /// Title
        TProductTitleText(title: product.productName ?? "No Title"),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        /// Stock Status
        Row(
          children: [
            TProductTitleText(title: "${LocaleKeys.statusLabel.tr()}: "),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(
              (selectedVariant?.stock ?? 0) > 0
                  ? LocaleKeys.in_stock.tr()
                  : "Out of Stock",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        /// Brand
        Row(
          children: [
            TCircularImage(
              image: "assets/logos/logo.png",
              width: 32,
              height: 32,
            ),
            TBrandTitleWithVerifiedIcon(
              title: LocaleKeys.brandName.tr(),
              brandTextSizes: TextSizes.medium,
            ),
          ],
        ),
      ],
    );
  }
}
