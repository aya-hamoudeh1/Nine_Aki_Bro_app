import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/helpers/helper_functions.dart';
import '../../../../core/widgets/custom_shapes/containers/rounded_container.dart';
import '../../logic/models/address_model.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({super.key, required this.address, required this.onTap});

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final isSelected = address.isDefault;

    return InkWell(
      onTap: onTap,
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.md),
        width: double.infinity,
        showBorder: true,
        backgroundColor:
            isSelected ? TColors.primary.withAlpha(128) : Colors.transparent,
        borderColor:
            isSelected
                ? Colors.transparent
                : dark
                ? TColors.darkerGrey
                : TColors.grey,
        margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
        // --- بدأ التعديل هنا ---
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: TSizes.sm / 2),
                  Text(
                    address.phoneNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: TSizes.sm / 2),
                  Text(address.formattedAddress, softWrap: true),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Iconsax.tick_circle5,
                color: dark ? TColors.light : TColors.dark.withAlpha(153),
              ),
          ],
        ),
      ),
    );
  }
}
