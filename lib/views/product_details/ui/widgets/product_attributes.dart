import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/helpers/helper_functions.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/models/product_variants_model.dart';
import '../../../../core/widgets/chips/choice_chip.dart';
import '../../../../core/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../core/widgets/texts/product_title_text.dart';
import '../../../../core/widgets/texts/section_heading.dart';
import '../../../../core/widgets/texts/t_product_price_text.dart';

class TProductAttributes extends StatefulWidget {
  const TProductAttributes({
    super.key,
    required this.product,
    required this.onVariantSelected,
  });

  final ProductModel product;
  final ValueChanged<ProductVariantModel> onVariantSelected;

  @override
  State<TProductAttributes> createState() => _TProductAttributesState();
}

class _TProductAttributesState extends State<TProductAttributes> {
  ProductVariantModel? _selectedVariant;
  String? _selectedColor;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    if (widget.product.variants.isNotEmpty) {
      _selectedVariant = widget.product.variants.first;
      _selectedColor = _selectedVariant?.color;
      _selectedSize = _selectedVariant?.size;
    }
  }

  void _updateSelection() {
    if (_selectedColor == null || _selectedSize == null) return;

    final newVariant = widget.product.variants.firstWhere(
      (v) => v.color == _selectedColor && v.size == _selectedSize,
      orElse: () => _selectedVariant!, // Should not happen if logic is correct
    );

    setState(() {
      _selectedVariant = newVariant;
    });

    // Notify the parent widget about the change
    widget.onVariantSelected(_selectedVariant!);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    if (widget.product.variants.isEmpty) {
      return const SizedBox.shrink(); // Don't show anything if no variants
    }

    // Get unique colors
    final availableColors =
        widget.product.variants.map((v) => v.color).toSet().toList();

    // Get sizes available for the currently selected color
    final availableSizes =
        widget.product.variants
            .where((v) => v.color == _selectedColor)
            .map((v) => v.size)
            .toSet()
            .toList();

    return Column(
      children: [
        /// Selected Attributes Pricing & Description
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.md),
          backgroundColor: dark ? TColors.darkGrey : TColors.grey,
          child: Column(
            children: [
              Row(
                children: [
                  TSectionHeading(
                    title: LocaleKeys.variation.tr(),
                    showActionButton: false,
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TProductTitleText(
                            title: "${LocaleKeys.price.tr()}: ",
                            smallSize: true,
                          ),
                          TProductPriceText(
                            price:
                                _selectedVariant?.price.toStringAsFixed(2) ??
                                'N/A',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TProductTitleText(
                            title: "${LocaleKeys.stock.tr()}: ",
                            smallSize: true,
                          ),
                          Text(
                            (_selectedVariant?.stock ?? 0) > 0
                                ? LocaleKeys.in_stock.tr()
                                : "Out of Stock",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// -- Colors --
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TSectionHeading(
              title: LocaleKeys.colors.tr(),
              showActionButton: false,
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children:
                  availableColors.map((color) {
                    return TChoiceChip(
                      text: color,
                      selected: _selectedColor == color,
                      onSelected: (isSelected) {
                        if (isSelected) {
                          setState(() {
                            _selectedColor = color;
                            // When color changes, select the first available size for that color
                            _selectedSize =
                                widget.product.variants
                                    .firstWhere(
                                      (v) => v.color == _selectedColor,
                                    )
                                    .size;
                          });
                          _updateSelection();
                        }
                      },
                    );
                  }).toList(),
            ),
          ],
        ),

        const SizedBox(height: TSizes.spaceBtwItems),

        /// -- Sizes --
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TSectionHeading(
              title: LocaleKeys.sizes.tr(),
              showActionButton: false,
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children:
                  availableSizes.map((size) {
                    return TChoiceChip(
                      text: size,
                      selected: _selectedSize == size,
                      onSelected: (isSelected) {
                        if (isSelected) {
                          setState(() {
                            _selectedSize = size;
                          });
                          _updateSelection();
                        }
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
