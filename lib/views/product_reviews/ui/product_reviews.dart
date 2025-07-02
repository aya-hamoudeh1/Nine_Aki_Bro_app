import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/product_reviews/ui/widgets/rating_progress_indicator.dart';
import 'package:nine_aki_bro_app/views/product_reviews/ui/widgets/user_review_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/helpers/helper_functions.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/appbar/appbar.dart';
import '../../../core/widgets/products/rating/rating_indicator.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../../auth/logic/cubit/authentication_cubit.dart';
import '../../product_details/logic/cubit/product_details_cubit.dart';

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return BlocProvider(
      create:
          (context) =>
              ProductDetailsCubit()
                ..getRates(productId: widget.productModel.productId!),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {},
        builder: (context, state) {
          ProductDetailsCubit cubit = context.read<ProductDetailsCubit>();
          return Scaffold(
            /// Appbar
            appBar: TAppBar(
              title: Text(LocaleKeys.reviewsAndRatings.tr()),
              showBackArrow: true,
            ),

            /// Body
            body:
                state is GetRateLoading || state is AddCommentLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                      padding: const EdgeInsets.only(
                        left: TSizes.defaultSpace,
                        right: TSizes.defaultSpace,
                        bottom: 80,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LocaleKeys.reviewsDescription.tr()),
                            const SizedBox(height: TSizes.spaceBtwItems),

                            /// Overall Product Ratings
                            const TOverallProductRating(),
                            TRatingBarSelector(
                              initialRating: cubit.averageRate.toDouble(),
                              isReadOnly: true,
                              onRatingUpdate: (p0) {},
                            ),
                            Text(
                              '12,611',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),

                            /// User Reviews List
                            StreamBuilder(
                              stream: Supabase.instance.client
                                  .from('comments')
                                  .stream(primaryKey: ['comment_id'])
                                  .eq(
                                    "for_product",
                                    widget.productModel.productId!,
                                  )
                                  .order('created_at'),
                              builder: (_, snapshot) {
                                List<Map<String, dynamic>>? data =
                                    snapshot.data;
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  return ListView.separated(
                                    separatorBuilder:
                                        (context, index) => const Divider(
                                          color: TColors.darkGrey,
                                          thickness: 0.5,
                                          indent: 60,
                                          endIndent: 60,
                                        ),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: data?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final commentData = data![index];
                                      return UserReviewCard(
                                        userName:
                                            commentData['user_name'] ??
                                            LocaleKeys.anonymousUser.tr(),
                                        comment: commentData['comment'] ?? '',
                                        storeReply: commentData['reply'],
                                      );
                                    },
                                  );
                                } else if (!snapshot.hasData) {
                                  return Center(
                                    child: Text(LocaleKeys.noCommentsYet.tr()),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      LocaleKeys.somethingWentWrong.tr(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
            bottomSheet: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: dark ? TColors.dark : TColors.light,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.typeYourFeedback.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      final authCubit = context.read<AuthenticationCubit>();
                      await authCubit.getUserData();
                      final userName =
                          authCubit.userDataModel?.name ??
                          LocaleKeys.defaultUserName.tr();
                      // send review
                      await cubit.addComment(
                        data: {
                          "comment": _commentController.text,
                          "for_user": cubit.userId,
                          "for_product": widget.productModel.productId,
                          "user_name": userName,
                        },
                      );
                      _commentController.clear();
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: TColors.primary,
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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
