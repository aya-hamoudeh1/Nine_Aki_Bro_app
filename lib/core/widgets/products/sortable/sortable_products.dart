import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/core/models/product_model.dart';
import 'package:nine_aki_bro_app/core/widgets/loaders/loading_widget.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/home/logic/home_cubit/home_cubit.dart';
import '../../../../views/cart/logic/cubit/cart_cubit/cart_cubit.dart';
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

          switch (_selectedSortOption) {
            case 'Name':
              displayProducts.sort(
                (a, b) => (a.productName ?? '').compareTo(b.productName ?? ''),
              );
              break;
            case 'Higher Price':
              displayProducts.sort((a, b) {
                final priceA = double.tryParse(a.price ?? '0') ?? 0.0;
                final priceB = double.tryParse(b.price ?? '0') ?? 0.0;
                return priceB.compareTo(priceA);
              });
              break;
            case 'Lower Price':
              displayProducts.sort((a, b) {
                final priceA = double.tryParse(a.price ?? '0') ?? 0.0;
                final priceB = double.tryParse(b.price ?? '0') ?? 0.0;
                return priceA.compareTo(priceB);
              });
              break;
            default:
              displayProducts.sort(
                (a, b) => (a.productName ?? '').compareTo(b.productName ?? ''),
              );
          }

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
                      context.read<CartCubit>().addToCart(product);
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
