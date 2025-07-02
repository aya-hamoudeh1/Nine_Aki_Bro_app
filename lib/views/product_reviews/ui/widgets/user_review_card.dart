import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:readmore/readmore.dart';
import '../../../../core/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/helpers/helper_functions.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({
    super.key,
    required this.userName,
    required this.comment,
    this.storeReply,
  });

  final String userName;
  final String comment;
  final String? storeReply;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/user.png"),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(userName, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Comment
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '01 Nov, 2023',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        ReadMoreText(
          comment,
          trimLines: 1,
          trimMode: TrimMode.Line,
          trimExpandedText: LocaleKeys.show_less.tr(),
          trimCollapsedText: LocaleKeys.show_more.tr(),
          moreStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: TColors.primary,
          ),
          lessStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: TColors.primary,
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// Company Review
        if (storeReply != null && storeReply!.isNotEmpty)
          TRoundedContainer(
            backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
            child: Padding(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.storeName.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "02 Nov, 2023",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ReadMoreText(
                    storeReply!,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimExpandedText: LocaleKeys.show_less.tr(),
                    trimCollapsedText: LocaleKeys.show_more.tr(),
                    moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                    ),
                    lessStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: TColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }
}
