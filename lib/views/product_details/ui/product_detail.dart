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
import '../../../../core/models/product_model.dart';
import '../../../../core/models/product_variants_model.dart';
import '../../../../core/widgets/texts/section_heading.dart';
import '../../../../core/constants/sizes.dart';
import '../../product_reviews/ui/product_reviews.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductVariantModel? selectedVariant;

  @override
  void initState() {
    super.initState();
    if (widget.productModel.variants.isNotEmpty) {
      setState(() {
        selectedVariant = widget.productModel.variants.first;
      });
    }
  }

  void onVariantSelected(ProductVariantModel variant) {
    setState(() {
      selectedVariant = variant;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TBottomAddToCart(
        product: widget.productModel,
        selectedVariant: selectedVariant,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 1. Product Image Slider
            TProductImageSlider(
              product: widget.productModel,
              selectedImageUrl:
                  selectedVariant?.imageUrl ??
                  widget.productModel.imageUrl ??
                  '',
              onVariantSelected: onVariantSelected,
            ),

            /// 2. Product Details
            Padding(
              padding: const EdgeInsets.only(
                right: TSizes.defaultSpace,
                left: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  /// Rating & Share
                  TRatingAndShare(productModel: widget.productModel),

                  /// Price, Title, Stock, Brand
                  TProductMetaData(
                    product: widget.productModel,
                    selectedVariant: selectedVariant,
                  ),

                  /// Attributes (Color & Size selectors)
                  TProductAttributes(
                    product: widget.productModel,
                    onVariantSelected: onVariantSelected,
                  ),
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
                    widget.productModel.description ??
                        "No description available.",
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: LocaleKeys.show_more.tr(),
                    trimExpandedText: LocaleKeys.show_less.tr(),
                    moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    lessStyle: const TextStyle(
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
                                    productModel: widget.productModel,
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
