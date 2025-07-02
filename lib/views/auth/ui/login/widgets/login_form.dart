import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/sizes.dart';
import '../../../../../core/helpers/helper_functions.dart';
import '../../../../../core/helpers/show_msg.dart';
import '../../../../nav_bar/ui/navigation_menu.dart';
import '../../../logic/cubit/authentication_cubit.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({super.key});

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    final loginInfo = await context.read<AuthenticationCubit>().getLoginInfo();
    if (mounted) {
      setState(() {
        emailController.text = loginInfo['email'] ?? '';
        rememberMe = loginInfo['remember_me'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if (!rememberMe) {
            emailController.clear();
          }
          passwordController.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenu()),
          );
        }
        if (state is LoginError) {
          showMsg(context, state.message);
        }
      },
      builder: (context, state) {
        AuthenticationCubit cubit = context.read<AuthenticationCubit>();
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.spaceBtwSections,
            ),
            child: Column(
              children: [
                /// Email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: LocaleKeys.email.tr(),
                  ),
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
                ),
                const SizedBox(height: TSizes.spaceBtwInputField),

                /// Password
                TextFormField(
                  controller: passwordController,
                  obscureText: isPasswordHidden,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.password_check),
                    labelText: LocaleKeys.password.tr(),
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
                  validator:
                      (value) =>
                          value!.length < 6
                              ? LocaleKeys.password_min_length.tr()
                              : null,
                ),
                const SizedBox(height: TSizes.spaceBtwInputField / 2),

                /// Remember Me & Forget Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Remember Me
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        Text(LocaleKeys.remember_me.tr()),
                      ],
                    ),

                    /// Forget Password
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPassword(),
                          ),
                        );
                      },
                      child: Text(LocaleKeys.forgot_password.tr()),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        state is LoginLoading
                            ? null
                            : () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                cubit.login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  rememberMe: rememberMe,
                                );
                              }
                            },
                    child:
                        state is LoginLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Text(LocaleKeys.sign_in.tr()),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwItems),

                /// Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      LocaleKeys.create_account.tr(),
                      style: TextStyle(
                        color: dark ? Colors.white : TColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
