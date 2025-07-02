import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/core/widgets/loaders/loading_widget.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../helpers/show_msg.dart';
import '../../../views/auth/logic/cubit/authentication_cubit.dart';
import '../../../views/nav_bar/ui/navigation_menu.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is GoogleSignInSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenu()),
          );
        }
        if (state is GoogleSignInError) {
          showMsg(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        AuthenticationCubit cubit = context.read<AuthenticationCubit>();
        return state is GoogleSignInLoading
            ? const LoadingWidget()
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: TColors.grey),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () => cubit.signInWithGoogle(),
                    icon: const Image(
                      width: TSizes.iconMd,
                      height: TSizes.iconMd,
                      image: AssetImage('assets/logos/google_logo.png'),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: TColors.grey),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Image(
                      width: TSizes.iconMd,
                      height: TSizes.iconMd,
                      image: AssetImage('assets/logos/Facebook_Logo.png'),
                    ),
                  ),
                ),
              ],
            );
      },
    );
  }
}
