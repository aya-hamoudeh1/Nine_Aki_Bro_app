import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import '../../../../core/widgets/appbar/appbar.dart';
import '../../../../core/widgets/icons/t_notification_counter_icon.dart';
import '../../../../core/widgets/products/cart/cart_menu_icon.dart';
import '../../../../core/constants/colors.dart';
import '../../../cart/ui/cart.dart';
import '../../../notifications/logic/cubit/notification_cubit/notification_cubit.dart';
import '../../../notifications/notification_view.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.home_appbar_title.tr(),
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.apply(color: TColors.grey),
          ),
          Text(
            LocaleKeys.home_appbar_subtitle.tr(),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.apply(color: TColors.white),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                final count = context.read<NotificationCubit>().unreadCount;
                return TNotificationCounterIcon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                  counter: count,
                  iconColor: TColors.white,
                );
              },
            ),
            TCartCounterIcon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              iconColor: TColors.white,
            ),
          ],
        ),
      ],
    );
  }
}
