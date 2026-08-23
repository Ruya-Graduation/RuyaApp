import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const String _channelId = 'booking_reminders';
  static const String _channelName = 'Booking Reminders';
  static const String _channelDescription =
      'Reminders for your booked site visits';

  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationService({
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  }) : _notificationsPlugin =
            notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      tz.initializeTimeZones();
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('[NotificationService] Timezone init fallback: $e');
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);

    // Create high-importance Android channel
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.createNotificationChannel(androidChannel);
  }

  Future<bool> requestPermission() async {
    // iOS permission request
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    // Android 13+ Notification permission
    final notifStatus = await Permission.notification.request();
    if (!notifStatus.isGranted) {
      return false;
    }

    // Attempt exact alarm permission if available (fallback gracefully if not)
    try {
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    } catch (e) {
      debugPrint('[NotificationService] Exact alarm check error: $e');
    }

    return true;
  }

  Future<void> scheduleBookingReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    if (scheduledDateTime.isBefore(DateTime.now())) {
      debugPrint(
        '[NotificationService] Cannot schedule reminder in the past: $scheduledDateTime',
      );
      return;
    }

    tz.TZDateTime scheduledTzDateTime;
    try {
      scheduledTzDateTime = tz.TZDateTime(
        tz.local,
        scheduledDateTime.year,
        scheduledDateTime.month,
        scheduledDateTime.day,
        scheduledDateTime.hour,
        scheduledDateTime.minute,
      );
    } catch (e) {
      scheduledTzDateTime = tz.TZDateTime.from(scheduledDateTime, tz.local);
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Try exact scheduling first, fall back to inexact if permission denied
    try {
      await _notificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledTzDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint(
        '[NotificationService] Exact alarm failed, falling back to inexact: $e',
      );
      await _notificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledTzDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelReminder(int notificationId) async {
    await _notificationsPlugin.cancel(notificationId);
  }
}
