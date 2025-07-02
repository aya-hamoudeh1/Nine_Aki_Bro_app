import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/profile/widgets/profile_menu.dart';
import '../../core/widgets/appbar/appbar.dart';
import '../../core/widgets/images/t_circular_image.dart';
import '../../core/widgets/texts/section_heading.dart';
import '../../core/constants/sizes.dart';
import '../auth/logic/cubit/authentication_cubit.dart';
import '../auth/logic/models/user_model.dart';
import '../auth/ui/login/login_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            builder: (context, state) {
              UserDataModel? userDataModel =
                  context.read<AuthenticationCubit>().userDataModel;
              AuthenticationCubit cubit = context.read<AuthenticationCubit>();
              return state is LogoutLoading || state is GetUserDataLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      /// App Bar
                      TAppBar(
                        showBackArrow: true,
                        title: Text(
                          LocaleKeys.profile.tr(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),

                      /// Profile Picture
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            const TCircularImage(
                              image: "assets/images/user.png",
                              height: 80,
                              width: 80,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(LocaleKeys.changeProfilePicture.tr()),
                            ),
                          ],
                        ),
                      ),

                      /// Details
                      const SizedBox(height: TSizes.spaceBtwItems / 2),
                      const Divider(),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// Heading Profile Info
                      TSectionHeading(
                        title: LocaleKeys.profileInformation.tr(),
                        showActionButton: false,
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      TProfileMenu(
                        onPressed: () {},
                        title: LocaleKeys.name.tr(),
                        value:
                            userDataModel?.name ??
                            LocaleKeys.defaultUserName.tr(),
                      ),
                      TProfileMenu(
                        onPressed: () {},
                        title: LocaleKeys.email.tr(),
                        value:
                            userDataModel?.email ??
                            LocaleKeys.emailPlaceholder.tr(),
                      ),

                      const SizedBox(height: TSizes.spaceBtwItems),
                      const Divider(),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      /// Heading Personal Info
                      TSectionHeading(
                        title: LocaleKeys.personalInformation.tr(),
                        showActionButton: false,
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      TProfileMenu(
                        onPressed: () {},
                        title: LocaleKeys.phone_number.tr(),
                        value:
                            userDataModel?.phoneNumber ??
                            LocaleKeys.phoneNumberPlaceholder.tr(),
                      ),
                      TProfileMenu(
                        onPressed: () {},
                        title: LocaleKeys.address.tr(),
                        value:
                            userDataModel?.address ??
                            LocaleKeys.addressPlaceholder.tr(),
                      ),
                      const Divider(),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Center(
                        child:
                            state is LogoutLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : TextButton(
                                  onPressed: () async {
                                    await cubit.signOut();
                                  },
                                  child: Text(
                                    LocaleKeys.logout.tr(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                      ),
                    ],
                  );
            },
          ),
        ),
      ),
    );
  }
}
