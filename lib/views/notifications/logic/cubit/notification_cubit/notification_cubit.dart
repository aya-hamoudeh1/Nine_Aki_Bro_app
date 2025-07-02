import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/models/notification_model.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  final supabase = Supabase.instance.client;
  int unreadCount = 0;

  /// Fetch Notification
  Future<void> fetchNotifications() async {
    try {
      emit(NotificationLoading());

      final userId = supabase.auth.currentUser?.id;

      log('USER ID: $userId');
      log('TYPE: ${userId.runtimeType}');

      if (userId == null) {
        emit(NotificationError());
        return;
      }

      final response = await supabase
          .from('notifications')
          .select()
          .eq('for_user', userId)
          .order('created_at', ascending: false);

      final notifications =
          (response).map((json) => NotificationModel.fromJson(json)).toList();

      unreadCount = notifications.where((n) => n.isRead != true).length;

      log('Fetched notifications: ${notifications.length}');
      emit(NotificationSuccess(notifications));
    } catch (e) {
      log(e.toString());
      emit(NotificationError());
    }
  }

  /// Get Unread Notification Count
  Future<int> getUnreadCount() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      final response = await supabase
          .from('notifications')
          .select('is_read')
          .eq('for_user', userId)
          .eq('is_read', false);

      return response.length;
    } catch (_) {
      return 0;
    }
  }

  /// Make Notification As Read
  Future<void> markAsRead(String notificationId) async {
    try {
      await supabase
          .from('notifications')
          .update({'is_read': true}).eq('notifications_id', notificationId);

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        await fetchNotifications();
      }
    } catch (e) {
      log('Error marking notification as read: $e');
    }
  }
}
