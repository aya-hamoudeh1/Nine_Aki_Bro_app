import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/core/widgets/loaders/loading_widget.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/address/logic/cubit/address_cubit.dart';
import 'package:nine_aki_bro_app/views/address/ui/widgets/single_address.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../../../core/widgets/appbar/appbar.dart';
import 'add_new_address.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (BuildContext innerContext) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                innerContext,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: innerContext.read<AddressCubit>(),
                        child: const AddNewAddressScreen(),
                      ),
                ),
              );
            },
            backgroundColor: TColors.primary,
            child: const Icon(Iconsax.add, color: TColors.white),
          );
        }
      ),
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          LocaleKeys.address.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: BlocBuilder<AddressCubit, AddressState>(
            builder: (context, state) {
              if (state is AddressLoading) {
                return LoadingWidget();
              }
              if (state is AddressFailure) {
                return Center(
                  child: Text('${LocaleKeys.error.tr()}: ${state.message}'),
                );
              }
              if (state is AddressSuccess) {
                if (state.addresses.isEmpty) {
                  return Center(child: Text(LocaleKeys.noAddressesFound.tr()));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.addresses.length,
                  itemBuilder: (_, index) {
                    final address = state.addresses[index];
                    return TSingleAddress(
                      address: address,
                      onTap: () {
                        context.read<AddressCubit>().selectDefaultAddress(
                          address.id,
                        );
                      },
                    );
                  },
                );
              }
              return Center(child: Text(LocaleKeys.fetchAddressesPrompt.tr()));
            },
          ),
        ),
      ),
    );
  }
}
