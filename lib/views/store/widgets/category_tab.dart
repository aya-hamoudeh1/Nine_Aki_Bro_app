import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../core/widgets/layouts/grid_layout.dart';
import '../../../core/widgets/loaders/loading_widget.dart';
import '../../../core/widgets/products/product_cards/product_card_vertical.dart';
import '../../../core/constants/sizes.dart';
import '../../home/logic/cubit/home_cubit.dart';

class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is GetCategoryProductLoading) {
                return Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: LoadingWidget(),
                );
              }
              if (cubit.categoryProduct.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(child: Text(LocaleKeys.noProductsFound.tr())),
                );
              }
              return TGridLayout(
                itemCount: cubit.categoryProduct.length,
                itemBuilder: (_, index) {
                  final product = cubit.categoryProduct[index];
                  final isFavorite = cubit.favoriteProduct.containsKey(
                    product.productId,
                  );

                  return TProductCardVertical(
                    productModel: product,
                    isFavorite: isFavorite,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
