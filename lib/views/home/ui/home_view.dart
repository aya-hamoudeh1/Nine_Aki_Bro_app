import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/core/widgets/loaders/loading_widget.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/home/ui/search_view.dart';
import 'package:nine_aki_bro_app/views/home/ui/widgets/home_appbar.dart';
import 'package:nine_aki_bro_app/views/home/ui/widgets/home_categories.dart';
import 'package:nine_aki_bro_app/views/home/ui/widgets/promo_slider.dart';
import '../../../core/helpers/helper_functions.dart';
import '../../../core/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../core/widgets/custom_shapes/containers/search_container.dart';
import '../../../core/widgets/layouts/grid_layout.dart';
import '../../../core/widgets/products/product_cards/product_card_vertical.dart';
import '../../../core/widgets/texts/section_heading.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../../all_products/all_products.dart';
import '../../cart/ui/cart.dart';
import '../../cart/logic/cubit/cart_cubit/cart_cubit.dart';
import '../logic/cubit/home_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // Listener can be kept for other state changes if needed
        },
        builder: (context, state) {
          final homeCubit = context.read<HomeCubit>();
          return RefreshIndicator(
            onRefresh: () async {
              await homeCubit.getProducts();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  /// Header
                  TPrimaryHeaderContainer(
                    child: Column(
                      children: [
                        const SizedBox(height: TSizes.spaceBtwItems),
                        const THomeAppBar(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        TSearchContainer(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchView(),
                              ),
                            );
                          },
                          text: LocaleKeys.search_in_store.tr(),
                          showBorder: false,
                          enableTextField: false,
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: TSizes.defaultSpace,
                          ),
                          child: Column(
                            children: [
                              TSectionHeading(
                                title: LocaleKeys.popular_categories.tr(),
                                showActionButton: false,
                                textColor: TColors.white,
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              THomeCategories(
                                categories:
                                    state is GetDataSuccess
                                        ? state.categories
                                        : [],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),

                  /// Body
                  Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      children: [
                        const TPromoSlider(
                          banners: [
                            "assets/images/t-shirt.png",
                            "assets/images/jeans.png",
                            'assets/images/jacket.png',
                            'assets/images/shoes.png',
                            "assets/images/belt.png",
                            "assets/images/bag.png",
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        TSectionHeading(
                          title: LocaleKeys.popular_product.tr(),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
                                      value: homeCubit,
                                      child: const AllProducts(),
                                    ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        if (state is GetDataLoading || state is HomeInitial)
                          const LoadingWidget()
                        else if (state is GetDataSuccess)
                          TGridLayout(
                            itemCount: state.products.length,
                            itemBuilder: (_, index) {
                              final product = state.products[index];
                              final isFavorite = homeCubit.checkIsFavorite(
                                product.productId!,
                              );
                              return TProductCardVertical(
                                isFavorite: isFavorite,
                                onPressed: () {
                                  isFavorite
                                      ? homeCubit.removeFromFavorite(
                                        product.productId!,
                                      )
                                      : homeCubit.addToFavorite(
                                        product.productId!,
                                      );
                                },
                                productModel: product,
                                onAddToCart: () {
                                  // --- **[THE FIX IS HERE]** ---
                                  // Check if the product has variants before adding to cart
                                  if (product.variants.isNotEmpty) {
                                    // Add the first available variant to the cart
                                    context.read<CartCubit>().addToCart(
                                      product,
                                      product.variants.first,
                                    );

                                    // Show a confirmation message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: TColors.primary,
                                        content: Text(
                                          LocaleKeys.item_added_to_cart.tr(),
                                          style: const TextStyle(
                                            color: TColors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        action: SnackBarAction(
                                          label: LocaleKeys.go_to_cart.tr(),
                                          textColor: TColors.primary,
                                          backgroundColor: TColors.white,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => const CartScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Optional: Show a message if a product has no variants and can't be added
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "This product has no available options to add.",
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          )
                        else if (state is GetDataError)
                          Center(
                            child: Text(
                              LocaleKeys.failed_to_load_products.tr(),
                            ),
                          )
                        else
                          Center(
                            child: Text(LocaleKeys.no_products_available.tr()),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
