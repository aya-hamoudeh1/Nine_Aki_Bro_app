import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/core/helpers/show_msg.dart';
import 'package:nine_aki_bro_app/views/address/logic/cubit/address_cubit.dart';
import 'package:nine_aki_bro_app/views/address/logic/models/address_model.dart';

import '../../../core/constants/sizes.dart';
import '../../../core/widgets/appbar/appbar.dart';
import '../../../generated/local_keys.g.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressState>(
      listener: (context, state) {
        if (state is AddressSuccess) {
          showMsg(context, LocaleKeys.addressAddedSuccessfully.tr());
          Navigator.pop(context);
        } else if (state is AddressFailure) {
          showMsg(
            context,
            '${LocaleKeys.failedToAddAddress.tr()}: ${state.message}',
          );
        }
      },
      child: Scaffold(
        appBar: TAppBar(
          showBackArrow: true,
          title: Text(LocaleKeys.addNewAddress.tr()),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      labelText: LocaleKeys.name.tr(),
                    ),
                    validator:
                        (value) => value!.isEmpty ? 'Name is required.' : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputField),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.mobile),
                      labelText: LocaleKeys.phoneNumber.tr(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? LocaleKeys.phoneNumberRequired.tr()
                                : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputField),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _streetController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.building_31),
                            labelText: LocaleKeys.street.tr(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? LocaleKeys.streetRequired.tr()
                                      : null,
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputField),
                      Expanded(
                        child: TextFormField(
                          controller: _postalCodeController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.code),
                            labelText: LocaleKeys.postalCodeOptional.tr(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputField),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.building),
                            labelText: LocaleKeys.city.tr(),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? LocaleKeys.cityRequired.tr()
                                      : null,
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputField),
                      Expanded(
                        child: TextFormField(
                          controller: _stateController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.activity),
                            labelText: LocaleKeys.stateOptional.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputField),
                  TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.global),
                      labelText: LocaleKeys.country.tr(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? LocaleKeys.countryRequired.tr()
                                : null,
                  ),
                  const SizedBox(height: TSizes.defaultSpace),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final addressCubit = context.read<AddressCubit>();

                          final newAddress = AddressModel(
                            id: '',
                            name: _nameController.text.trim(),
                            phoneNumber: _phoneNumberController.text.trim(),
                            street: _streetController.text.trim(),
                            city: _cityController.text.trim(),
                            country: _countryController.text.trim(),
                            state:
                                _stateController.text.trim().isEmpty
                                    ? null
                                    : _stateController.text.trim(),
                            postalCode:
                                _postalCodeController.text.trim().isEmpty
                                    ? null
                                    : _postalCodeController.text.trim(),
                            isDefault: false,
                          );
                          addressCubit.addNewAddress(newAddress);
                        }
                      },
                      child: Text(LocaleKeys.save.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
