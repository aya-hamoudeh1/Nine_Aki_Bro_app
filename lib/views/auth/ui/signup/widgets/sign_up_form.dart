import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/auth/ui/signup/widgets/skin_tone_selector.dart';
import 'package:nine_aki_bro_app/views/auth/ui/signup/widgets/term_and_conditions_box.dart';
import '../../../../../core/constants/sizes.dart';
import '../../../../../core/helpers/show_msg.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../nav_bar/ui/navigation_menu.dart';
import '../../../logic/cubit/authentication_cubit.dart';
import 'age_group_dropdown.dart';

class TSignUpForm extends StatefulWidget {
  const TSignUpForm({super.key, this.initialEmail, this.initialName});

  final String? initialEmail;
  final String? initialName;

  @override
  State<TSignUpForm> createState() => _TSignUpFormState();
}

class _TSignUpFormState extends State<TSignUpForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  String? selectedAgeGroup;
  Color? selectedSkinTone;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
    }
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenu()),
          );
        }
        if (state is SignUpError) {
          showMsg(context, state.message);
        }
      },
      builder: (context, state) {
        AuthenticationCubit cubit = context.read<AuthenticationCubit>();
        return Form(
          key: _formKey,
          child: Column(
            children: [
              /// Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.name.tr(),
                  prefixIcon: Icon(Iconsax.user),
                ),
                validator: TValidator.validateName,
              ),
              const SizedBox(height: TSizes.spaceBtwInputField),

              /// Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.email.tr(),
                  prefixIcon: Icon(Iconsax.direct),
                ),
                validator: TValidator.validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: TSizes.spaceBtwInputField),

              /// Password
              TextFormField(
                controller: _passwordController,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  labelText: LocaleKeys.password.tr(),
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                    icon: Icon(
                      isPasswordHidden ? Iconsax.eye_slash : Iconsax.eye,
                    ),
                  ),
                ),
                validator: TValidator.validatePassword,
              ),
              const SizedBox(height: TSizes.spaceBtwInputField),

              /// Phone Number
              TextFormField(
                controller: _phoneController,
                //expand : false,
                decoration: InputDecoration(
                  labelText: LocaleKeys.phone_number.tr(),
                  prefixIcon: Icon(Iconsax.call),
                ),
                validator: TValidator.validatePhoneNumber,
              ),
              const SizedBox(height: TSizes.spaceBtwInputField),

              /// Address
              TextFormField(
                controller: _addressController,
                //expand : false,
                decoration: InputDecoration(
                  labelText: LocaleKeys.address.tr(),
                  prefixIcon: Icon(Iconsax.location),
                ),
                validator: TValidator.validateAddress,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Text(
                LocaleKeys.age_skin_tip.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TSizes.spaceBtwInputField),

              /// Age
              AgeGroupDropdown(
                selectedValue: selectedAgeGroup,
                onChanged: (p0) {
                  setState(() {
                    selectedAgeGroup = p0;
                  });
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputField),

              /// Skin Color
              SkinToneSelector(
                selectedColor: selectedSkinTone,
                onColorSelected: (color) {
                  setState(() {
                    selectedSkinTone = color;
                  });
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Terms&Conditions checkbox
              const TTermAndConditionsBox(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      state is LoginLoading
                          ? null
                          : () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              cubit.signUp(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                phoneNumber: _phoneController.text,
                                address: _addressController.text,
                                ageGroup: selectedAgeGroup ?? '',
                                skinTone: selectedSkinTone,
                              );
                            }
                          },
                  child:
                      state is SignUpLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Text(LocaleKeys.create_account.tr()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
