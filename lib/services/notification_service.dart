import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initNotifications() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    if (Platform.isWindows) {
      _isInitialized = true;
      return;
    }

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    _isInitialized = true;
  }

  Future<void> showInstantNotification() async {
    if (Platform.isWindows) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'instant_channel',
          'Instant Notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      0,
      'StyleAI',
      'Your hairstyle preview is ready!',
      details,
    );
  }

  Future<void> scheduleDailyTip() async {
    var now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      10,
      0,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_channel',
          'Daily Style Tips',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final tips = [
      'Try a new hairstyle today!',
      'Explore trending styles now!',
      'Upgrade your look with AI!',
    ];
    final tipMessage = tips[now.day % tips.length];

    if (Platform.isWindows) return;

    await _notificationsPlugin.zonedSchedule(
      1,
      'StyleAI',
      tipMessage,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleReminder() async {
    var scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(minutes: 5));

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    if (Platform.isWindows) return;

    await _notificationsPlugin.zonedSchedule(
      2,
      'StyleAI',
      'Complete your hairstyle preview now!',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelReminder() async {
    if (Platform.isWindows) return;
    await _notificationsPlugin.cancel(2);
  }
}
