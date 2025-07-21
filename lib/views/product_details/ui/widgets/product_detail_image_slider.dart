import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/helpers/helper_functions.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/models/product_variants_model.dart';
import '../../../../core/widgets/appbar/appbar.dart';
import '../../../../core/widgets/custom_shapes/curved_edges/curved_edge_widget.dart';
import '../../../../core/widgets/icons/t_circular_icon.dart';
import '../../../../core/widgets/images/t_rounded_image.dart';

class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({
    super.key,
    required this.product,
    required this.selectedImageUrl,
    required this.onVariantSelected,
  });

  final ProductModel product;
  final String selectedImageUrl;
  final ValueChanged<ProductVariantModel> onVariantSelected;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    // Get unique variants by color to display in the slider
    final uniqueColorVariants = <String, ProductVariantModel>{};
    for (var variant in product.variants) {
      uniqueColorVariants.putIfAbsent(variant.color, () => variant);
    }
    final displayVariants = uniqueColorVariants.values.toList();

    return TCurvedEdgeWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          children: [
            /// Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(TSizes.productImageRadius * 2),
                child: Center(
                  child: Image(
                    image: NetworkImage(selectedImageUrl),
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: TColors.grey,
                        ),
                  ),
                ),
              ),
            ),

            /// Image Slider
            Positioned(
              right: 0,
              bottom: 30,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  itemCount: displayVariants.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder:
                      (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    final variant = displayVariants[index];
                    final isSelected = variant.imageUrl == selectedImageUrl;
                    return TRoundedImage(
                      width: 80,
                      backgroundColor: dark ? TColors.dark : TColors.white,
                      border: Border.all(
                        color:
                            isSelected ? TColors.primary : Colors.transparent,
                        width: 2,
                      ),
                      padding: const EdgeInsets.all(TSizes.sm),
                      imageUrl: variant.imageUrl,
                      isNetworkImage: true,
                      onPressed: () => onVariantSelected(variant),
                    );
                  },
                ),
              ),
            ),

            /// App Icons
            TAppBar(
              showBackArrow: true,
              actions: [
                AnimatedCircularIcon(
                  onPressed: () {},
                  icon: Iconsax.heart5,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
