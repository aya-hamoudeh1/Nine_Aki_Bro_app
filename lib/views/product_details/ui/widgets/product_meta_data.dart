import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../core/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../core/widgets/images/t_circular_image.dart';
import '../../../../core/widgets/texts/product_title_text.dart';
import '../../../../core/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import '../../../../core/widgets/texts/t_product_price_text.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/constants/sizes.dart';

class TProductMetaData extends StatelessWidget {
  const TProductMetaData({super.key});

  @override
  Widget build(BuildContext context) {
    //final darkMode = THelperFunction.isDarkMode(context);
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
                '25%',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.apply(color: TColors.black),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),

            /// Price
            Text(
              '\$250',
              style: Theme.of(context).textTheme.titleSmall!.apply(
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            const TProductPriceText(price: '175', isLarge: true),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        /// Title
        const TProductTitleText(title: "Green Nike Sports Shirt"),
        const SizedBox(height: TSizes.spaceBtwItems / 1.5),

        /// Stock Status
        Row(
          children: [
            TProductTitleText(title: LocaleKeys.statusLabel.tr()),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(
              LocaleKeys.stock.tr(),
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
              //overlayColor: darkMode ? TColors.white : TColors.black,
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
