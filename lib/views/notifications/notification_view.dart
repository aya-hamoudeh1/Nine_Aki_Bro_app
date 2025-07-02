import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/sizes.dart';
import '../../core/helpers/helper_functions.dart';
import '../../generated/local_keys.g.dart';
import 'logic/cubit/notification_cubit/notification_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool dialogShown = false;
  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      context.read<NotificationCubit>().fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.notifications.tr(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: dark ? TColors.white : TColors.primary,
          ),
        ),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationError) {
            return Center(child: Text(LocaleKeys.error_message.tr()));
          } else if (state is NotificationSuccess) {
            final notifications = state.notifications;
            final unreadNotifications =
                notifications.where((n) => n.isRead != true).toList();

            if (unreadNotifications.isEmpty && !dialogShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        backgroundColor: TColors.primary,
                        title: Text(
                          LocaleKeys.no_new_notifications.tr(),
                          style: TextStyle(color: TColors.white),
                        ),
                        content: Text(
                          LocaleKeys.no_new_notifications_desc.tr(),
                          style: TextStyle(color: TColors.white),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              LocaleKeys.ok.tr(),
                              style: TextStyle(
                                color: TColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                );
                dialogShown = true;
              });
            }

            if (notifications.isEmpty) {
              return Center(
                child: Text(LocaleKeys.no_notifications_found.tr()),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder:
                    (_, __) => const Divider(color: TColors.darkGrey),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final isRead = notification.isRead ?? false;
                  log('Notification ID: ${notification.id} - Is Read: $isRead');
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          isRead ? Colors.transparent : TColors.darkContainer,
                      border: Border.all(color: TColors.darkGrey),
                    ),
                    child: ListTile(
                      leading: Icon(
                        isRead
                            ? Iconsax.notification
                            : Iconsax.notification_bing,
                        color: isRead ? TColors.darkGrey : Colors.amber,
                      ),
                      title: Text(
                        notification.title ?? LocaleKeys.no_title.tr(),
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: dark ? TColors.white : TColors.primary,
                        ),
                      ),
                      subtitle: Text(
                        notification.body ?? LocaleKeys.no_body.tr(),
                      ),
                      trailing: Text(
                        notification.createdAt != null
                            ? DateFormat(
                              'dd/MM/yyyy',
                            ).format(notification.createdAt!)
                            : '',
                        style: const TextStyle(fontSize: 12),
                      ),
                      //tileColor: isRead ? Colors.grey[100] : Colors.white,
                      onTap: () {
                        final cubit = context.read<NotificationCubit>();
                        if (!isRead && notification.id != null) {
                          cubit.markAsRead(notification.id!);
                          setState(() {});
                        }
                      },
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
