import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/product_details/ui/widgets/bottom_add_to_cart_widget.dart';
import 'package:nine_aki_bro_app/views/product_details/ui/widgets/product_attributes.dart';
import 'package:nine_aki_bro_app/views/product_details/ui/widgets/product_detail_image_slider.dart';
import 'package:nine_aki_bro_app/views/product_details/ui/widgets/product_meta_data.dart';
import 'package:nine_aki_bro_app/views/product_details/ui/widgets/rating_share_widget.dart';
import 'package:readmore/readmore.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/texts/section_heading.dart';
import '../../../core/constants/sizes.dart';
import '../../product_reviews/ui/product_reviews.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            const TProductImageSlider(),

            /// Product Details
            Padding(
              padding: const EdgeInsets.only(
                right: TSizes.defaultSpace,
                left: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  /// Rating & Share
                  TRatingAndShare(productModel: productModel),

                  /// Price, Title, Stock, Brand
                  const TProductMetaData(),

                  /// Attributes
                  const TProductAttributes(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(LocaleKeys.checkout.tr()),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Description
                  TSectionHeading(
                    title: LocaleKeys.description.tr(),
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ReadMoreText(
                    LocaleKeys.product_description.tr(),
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: LocaleKeys.show_more.tr(),
                    trimExpandedText: LocaleKeys.show_less.tr(),
                    moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    lessStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  /// Reviews
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TSectionHeading(
                        title: "Reviews(199)",
                        showActionButton: false,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductReviewsScreen(
                                    productModel: productModel,
                                  ),
                            ),
                          );
                        },
                        icon: const Icon(Iconsax.arrow_right_3, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
