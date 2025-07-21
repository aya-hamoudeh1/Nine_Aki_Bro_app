import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/helpers/helper_functions.dart';
import '../../../../core/models/purchase_model.dart';
import '../../../../core/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../home/logic/cubit/home_cubit.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final userOrders = context.read<HomeCubit>().userOrders;
        return ListView.separated(
          shrinkWrap: true,
          itemCount: userOrders.length,
          separatorBuilder:
              (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
          itemBuilder: (context, index) {
            final order = userOrders[index];
            final purchase = order.purchase?.firstWhere(
              (p) => p.forUser == context.read<HomeCubit>().userId,
              orElse: () => Purchase(),
            );
            return TRoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(TSizes.md),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Row 1
                  Row(
                    children: [
                      /// 1 - Icon
                      const Icon(Iconsax.ship),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),

                      /// 2 - Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${LocaleKeys.order_status.tr()} ${purchase?.status ?? LocaleKeys.not_available.tr()}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.apply(
                                color: TColors.primary,
                                fontWeightDelta: 1,
                              ),
                            ),
                            Text(
                              '${LocaleKeys.order_date.tr()} ${purchase?.createdAt?.toLocal().toString().split(' ')[0] ?? LocaleKeys.na.tr()}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),

                      /// 3 - Icon
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Iconsax.arrow_right_34,
                          size: TSizes.iconSm,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// Row 2
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            /// 1 - Icon
                            const Icon(Iconsax.tag),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),

                            /// 2 - Status & Date
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.order_id.tr(),
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    purchase?.purchaseId ??
                                        LocaleKeys.not_available.tr(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            /// 1 - Icon
                            const Icon(Iconsax.calendar),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),

                            /// 2 - Status & Date
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.shipping_date.tr(),
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    purchase?.createdAt
                                            ?.toLocal()
                                            .toString()
                                            .split(' ')[0] ??
                                        LocaleKeys.na.tr(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
