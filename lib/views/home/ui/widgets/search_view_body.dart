import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../core/widgets/appbar/appbar.dart';
import '../../../../core/widgets/custom_shapes/containers/search_container.dart';
import '../../../../core/widgets/layouts/grid_layout.dart';
import '../../../../core/widgets/products/product_cards/product_card_vertical.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/models/product_model.dart';
import '../../logic/home_cubit/home_cubit.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({super.key});

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return Scaffold(
      body: ListView(
        children: [
          TAppBar(
            showBackArrow: true,
            title: Text(LocaleKeys.search_results_title.tr()),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// Search Field
          TSearchContainer(
            text: LocaleKeys.search_in_store.tr(),
            enableTextField: true,
            controller: _searchController,
            query: _searchController.text,
            onChanged: (value) {
              homeCubit.search(value);
            },
          ),

          /// Results Section
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                HomeCubit homeCubit = context.read<HomeCubit>();
                List<ProductModel> products =
                    context.read<HomeCubit>().products;
                final results = homeCubit.searchResults;
                final isSearching = homeCubit.isSearching;

                if (state is GetDataLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (isSearching && results.isEmpty) {
                  return Center(child: Text(LocaleKeys.no_results_found.tr()));
                }

                return TGridLayout(
                  itemCount: results.length,
                  itemBuilder:
                      (_, index) => TProductCardVertical(
                        isFavorite: homeCubit.checkIsFavorite(
                          products[index].productId!,
                        ),
                        onPressed: () {
                          homeCubit.addToFavorite(products[index].productId!);
                        },
                        productModel: results[index],
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
