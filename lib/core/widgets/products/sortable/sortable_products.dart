import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/core/models/product_model.dart';
import 'package:nine_aki_bro_app/core/widgets/loaders/loading_widget.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../views/cart/logic/cubit/cart_cubit/cart_cubit.dart';
import '../../../../views/home/logic/cubit/home_cubit.dart';
import '../../../constants/sizes.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class TSortableProducts extends StatefulWidget {
  const TSortableProducts({super.key});

  @override
  State<TSortableProducts> createState() => _TSortableProductsState();
}

class _TSortableProductsState extends State<TSortableProducts> {
  String _selectedSortOption = 'Name';

  Map<String, String> get sortOptions {
    return {
      'Name': LocaleKeys.sortByName.tr(),
      'Higher Price': LocaleKeys.sortByHigherPrice.tr(),
      'Lower Price': LocaleKeys.sortByLowerPrice.tr(),
      'Sale': LocaleKeys.sortBySale.tr(),
      'Newest': LocaleKeys.sortByNewest.tr(),
      'Popularity': LocaleKeys.sortByPopularity.tr(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is GetDataLoading || state is HomeInitial) {
          return const Center(child: LoadingWidget());
        }

        if (state is GetDataSuccess) {
          if (state.products.isEmpty) {
            return Center(child: Text(LocaleKeys.noProductsFound.tr()));
          }

          final List<ProductModel> displayProducts = List.from(state.products);

          // Sorting logic based on variants if they exist
          displayProducts.sort((a, b) {
            final priceA =
                a.variants.isNotEmpty
                    ? a.variants.first.price
                    : double.tryParse(a.price ?? '0') ?? 0.0;
            final priceB =
                b.variants.isNotEmpty
                    ? b.variants.first.price
                    : double.tryParse(b.price ?? '0') ?? 0.0;

            switch (_selectedSortOption) {
              case 'Higher Price':
                return priceB.compareTo(priceA);
              case 'Lower Price':
                return priceA.compareTo(priceB);
              case 'Name':
              default:
                return (a.productName ?? '').compareTo(b.productName ?? '');
            }
          });

          return Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.sort),
                ),
                value: _selectedSortOption,
                items:
                    sortOptions.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSortOption = value ?? 'Name';
                  });
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TGridLayout(
                itemCount: displayProducts.length,
                itemBuilder: (_, index) {
                  final product = displayProducts[index];
                  final isFavorite = homeCubit.checkIsFavorite(
                    product.productId!,
                  );

                  return TProductCardVertical(
                    productModel: product,
                    isFavorite: isFavorite,
                    onPressed: () {
                      if (isFavorite) {
                        homeCubit.removeFromFavorite(product.productId!);
                      } else {
                        homeCubit.addToFavorite(product.productId!);
                      }
                    },
                    onAddToCart: () {
                      // --- **[THE FIX IS HERE]** ---
                      if (product.variants.isNotEmpty) {
                        context.read<CartCubit>().addToCart(
                          product,
                          product.variants.first,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(LocaleKeys.item_added_to_cart.tr()),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Product has no options to add."),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          );
        }

        if (state is GetDataError) {
          return Center(child: Text(LocaleKeys.failedToLoadProducts.tr()));
        }

        return Center(child: Text(LocaleKeys.noProductsAvailable.tr()));
      },
    );
  }
}
