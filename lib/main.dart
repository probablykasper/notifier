import 'package:awesome_notifications/awesome_notifications.dart'
    show AwesomeNotifications, NotificationChannel;
import 'package:flutter/material.dart'
    show Colors, ThemeData, ThemeMode, runApp;
import 'package:notifier/scheduler.dart' show scheduleNotifications;
import 'theme.dart' show getTheme, initializeTheme;
import 'list_page.dart' show ListPage;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:get/get.dart' show GetMaterialApp;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

var prefsFuture = SharedPreferences.getInstance();

void main() async {
  // Be sure to add this line if AndroidAlarmManager.initialize() call happens before runApp()
  // WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/res_notification_icon',
      [
        NotificationChannel(
          channelKey: 'scheduled_notifications',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Scheduled notifications configured by the user',
          defaultColor: Colors.blue,
          ledColor: Colors.white,
        )
      ],
      debug: true);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(
    GetMaterialApp(
      title: 'Notifier',
      debugShowCheckedModeBanner: false,
      theme: getTheme(false),
      darkTheme: getTheme(true),
      themeMode: ThemeMode.system,
      home: ListPage(),
    ),
  );
  initializeTheme();

  await AndroidAlarmManager.initialize();
  scheduleNotifications();
}
