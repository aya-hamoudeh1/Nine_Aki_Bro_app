import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/auth/ui/password_configuration/reset_password.dart';
import '../../../../core/constants/sizes.dart';
import 'package:email_validator/email_validator.dart';

import '../../../../core/helpers/show_msg.dart';
import '../../logic/cubit/authentication_cubit.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess) {
          final email = emailController.text;
          emailController.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPassword(email: email),
            ),
          );
        } else if (state is PasswordResetError) {
          showMsg(context, LocaleKeys.error_generic.tr());
        }
      },
      builder: (context, state) {
        AuthenticationCubit cubit = context.read<AuthenticationCubit>();
        return Scaffold(
          appBar: AppBar(),
          body:
              state is PasswordResetLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Headings
                          Text(
                            LocaleKeys.forget_password_title.tr(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),

                          const SizedBox(height: TSizes.spaceBtwItems),

                          Text(
                            LocaleKeys.forget_password_subtitle.tr(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),

                          const SizedBox(height: TSizes.spaceBtwSections * 2),

                          /// Text field
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocaleKeys.please_enter_email.tr();
                              }
                              if (!EmailValidator.validate(value)) {
                                return LocaleKeys.enter_valid_email.tr();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: LocaleKeys.email.tr(),
                              prefixIcon: Icon(Iconsax.direct_right),
                            ),
                          ),

                          const SizedBox(height: TSizes.spaceBtwSections),

                          /// Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.resetPassword(
                                    email: emailController.text,
                                  );
                                }
                              },
                              child: Text(LocaleKeys.submit.tr()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
