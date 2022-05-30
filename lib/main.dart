import 'package:flutter/material.dart' show ThemeMode, runApp;
// import 'package:notifier/notification_items.dart' show scheduleNotifications;
import 'theme.dart' show getTheme, initializeTheme;
import 'list_page.dart' show ListPage;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:get/get.dart' show GetMaterialApp;
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart'
//     show AndroidAlarmManager;

var prefsFuture = SharedPreferences.getInstance();

void main() async {
  // Be sure to add this line if AndroidAlarmManager.initialize() call happens before runApp()
  // WidgetsFlutterBinding.ensureInitialized();

  // await AndroidAlarmManager.initialize();

  runApp(
    GetMaterialApp(
        title: 'Notifier',
        // debugShowCheckedModeBanner: false,
        theme: getTheme(false),
        darkTheme: getTheme(true),
        themeMode: ThemeMode.system,
        home: ListPage()),
  );
  initializeTheme();

  // scheduleNotifications();
}
