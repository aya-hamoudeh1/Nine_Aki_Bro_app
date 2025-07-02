import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';

import '../../../core/widgets/texts/section_heading.dart';
import '../../../core/constants/sizes.dart';

class TBillingPaymentSection extends StatelessWidget {
  const TBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TSectionHeading(
          title: LocaleKeys.paymentMethod.tr(),
          showActionButton: false,
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Row(
          children: [
            Icon(Iconsax.money_send, size: 24),
            const SizedBox(width: TSizes.spaceBtwItems / 2),
            Text(
              LocaleKeys.cashOnDelivery.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
