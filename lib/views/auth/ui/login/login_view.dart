import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/views/auth/logic/cubit/authentication_cubit.dart';
import 'package:nine_aki_bro_app/views/auth/ui/login/widgets/login_form.dart';
import 'package:nine_aki_bro_app/views/auth/ui/login/widgets/login_header.dart';
import '../../../../core/widgets/login_signup/form_divider.dart';
import '../../../../core/widgets/login_signup/social_button.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../generated/local_keys.g.dart';
import '../signup/signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is GoogleSignInNeedsProfileCompletion) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SignUpScreen(
                    initialEmail: state.email,
                    initialName: state.name,
                  ),
            ),
          );
        }
      },
      child:
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [

                /// Logo , Title & Sub-Title
                const TLoginHeader(),

                /// Form
                const TLoginForm(),

                /// Divider
                TFormDivider(dividerText: LocaleKeys.or_sign_in_with.tr()),
                const SizedBox(height: TSizes.spaceBtwSections),

                /// Footer
                const TSocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}