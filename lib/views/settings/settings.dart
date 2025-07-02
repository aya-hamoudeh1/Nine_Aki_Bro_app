import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/address/logic/cubit/address_cubit.dart';
import 'package:nine_aki_bro_app/views/address/logic/repos/address_repo.dart';
import '../../core/helpers/helper_functions.dart';
import '../../core/widgets/appbar/appbar.dart';
import '../../core/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../core/widgets/list_tiles/settings_menu_tile.dart';
import '../../core/widgets/list_tiles/user_profile_tile.dart';
import '../../core/widgets/texts/section_heading.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/sizes.dart';
import '../address/ui/address.dart';
import '../order/ui/order.dart';
import '../profile/profile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  TAppBar(
                    title: Text(
                      LocaleKeys.account.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: TColors.white),
                    ),
                  ),

                  /// User Profile Card
                  TUserProfileTile(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            /// Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// Account Setting
                  TSectionHeading(
                    title: LocaleKeys.accountSettings.tr(),
                    textColor: dark ? TColors.white : TColors.primary,
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TSettingMenuTile(
                    icon: Iconsax.safe_home,
                    title: LocaleKeys.myAddresses.tr(),
                    subTitle: LocaleKeys.myAddressesSub.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider(
                                create:
                                    (context) =>
                                        AddressCubit(AddressRepository()),
                                child: const UserAddressScreen(),
                              ),
                        ),
                      );
                    },
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: LocaleKeys.myCart.tr(),
                    subTitle: LocaleKeys.myCartSub.tr(),
                    onTap: () {},
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.bag_tick,
                    title: LocaleKeys.myOrder.tr(),
                    subTitle: LocaleKeys.myOrderSub.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderScreen(),
                        ),
                      );
                    },
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.bank,
                    title: LocaleKeys.bankAccount.tr(),
                    subTitle: LocaleKeys.bankAccountSub.tr(),
                    onTap: () {},
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.discount_shape,
                    title: LocaleKeys.myCoupons.tr(),
                    subTitle: LocaleKeys.myCouponsSub.tr(),
                    onTap: () {},
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.notification,
                    title: LocaleKeys.notifications.tr(),
                    subTitle: LocaleKeys.notificationsSub.tr(),
                    onTap: () {},
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.security_card,
                    title: LocaleKeys.accountPrivacy.tr(),
                    subTitle: LocaleKeys.accountPrivacySub.tr(),
                    onTap: () {},
                  ),

                  /// App Settings
                  const SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(
                    title: LocaleKeys.appSettings.tr(),
                    textColor: dark ? TColors.white : TColors.primary,
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TSettingMenuTile(
                    icon: Iconsax.document_upload,
                    title: LocaleKeys.loadData.tr(),
                    subTitle: "Upload Data to Your Cloud Firebase",
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.location,
                    title: LocaleKeys.geolocation.tr(),
                    subTitle: LocaleKeys.geolocationSub.tr(),
                    trailing: Switch(value: true, onChanged: (value) {}),
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.security_user,
                    title: LocaleKeys.safeMode.tr(),
                    subTitle: LocaleKeys.safeModeSub.tr(),
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                  TSettingMenuTile(
                    icon: Iconsax.image,
                    title: LocaleKeys.hdImagesQuality.tr(),
                    subTitle: LocaleKeys.hdImagesQualitySub.tr(),
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
