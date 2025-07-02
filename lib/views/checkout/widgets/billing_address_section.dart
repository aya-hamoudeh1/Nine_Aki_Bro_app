import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/views/address/logic/cubit/address_cubit.dart';
import 'package:nine_aki_bro_app/views/address/ui/address.dart';

import '../../../core/widgets/texts/section_heading.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../../../generated/local_keys.g.dart';
import '../../address/logic/models/address_model.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TSectionHeading(
              title: LocaleKeys.pickupAddress.tr(),
              buttonTitle: LocaleKeys.change.tr(),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserAddressScreen()),
                  ),
            ),
            if (state is AddressSuccess) ...[
              _buildAddressDetails(context, state.addresses),
            ] else if (state is AddressLoading) ...[
              const CircularProgressIndicator(),
            ] else ...[
              Text(
                LocaleKeys.noAddressSelected.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAddressDetails(
    BuildContext context,
    List<AddressModel> addresses,
  ) {
    final defaultAddress = addresses.firstWhere(
      (address) => address.isDefault,
      orElse:
          () =>
              addresses.isNotEmpty
                  ? addresses.first
                  : AddressModel(
                    id: '',
                    name: LocaleKeys.noName.tr(),
                    phoneNumber: '',
                    street: '',
                    city: LocaleKeys.pleaseSelectAddress.tr(),
                    country: '',
                  ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(defaultAddress.name, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Row(
          children: [
            const Icon(Icons.phone, color: TColors.grey, size: 16),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(
              defaultAddress.phoneNumber,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Row(
          children: [
            Icon(Iconsax.location, color: TColors.grey, size: 16),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: Text(
                defaultAddress.formattedAddress,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
