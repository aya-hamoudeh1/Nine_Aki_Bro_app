import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/widgets/products/rating/rating_indicator.dart';
import '../../logic/cubit/product_details_cubit.dart';
import '../product_detail.dart';

class TRatingAndShare extends StatelessWidget {
  const TRatingAndShare({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ProductDetailsCubit()
                ..getRates(productId: productModel.productId!),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state is AddOrUpdateRateSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        ProductDetailScreen(productModel: productModel),
              ),
            );
          }
        },
        builder: (context, state) {
          ProductDetailsCubit cubit = context.read<ProductDetailsCubit>();
          return state is GetRateLoading || state is AddOrUpdateRateLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Rating
                      Row(
                        children: [
                          const Icon(
                            Iconsax.star5,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems / 2),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${cubit.averageRate}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const TextSpan(text: '(199)'),
                              ],
                            ),
                          ),
                        ],
                      ),

                      /// Share Button
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share, size: TSizes.iconMd),
                      ),
                    ],
                  ),
                  TRatingBarSelector(
                    initialRating: cubit.userRate.toDouble(),
                    onRatingUpdate: (rating) {
                      cubit.addOrUpdateUserRate(
                        productId: productModel.productId!,
                        data: {
                          "rate": rating.toInt(),
                          "for_user": cubit.userId,
                          "for_product": productModel.productId!,
                        },
                      );
                    },
                  ),
                ],
              );
        },
      ),
    );
  }
}
