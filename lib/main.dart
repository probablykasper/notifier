import 'dart:isolate' show Isolate;
import 'dart:ui';
import 'package:flutter/material.dart'
    show ThemeData, ThemeMode, WidgetsFlutterBinding, runApp;
import 'package:flutter/scheduler.dart';
import 'theme.dart' show getTheme;
import 'list_page.dart' show ListPage;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:get/get.dart' show Get, GetMaterialApp, GetNavigation;

var prefsFuture = SharedPreferences.getInstance();

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // var prefs = prefsFuture.then((prefs) {

  // })
  // var darkMode = prefs.getBool('darkMode') ?? true;
  runApp(
    GetMaterialApp(
        title: 'Notifier',
        // debugShowCheckedModeBanner: false,
        theme: getTheme(false),
        darkTheme: getTheme(true),
        themeMode: ThemeMode.system,
        home: ListPage()),
  );
  setupDarkMode();
}

void setupDarkMode() async {
  var prefs = await prefsFuture;
  var darkMode = prefs.getBool("darkMode");
  if (darkMode == null) {
    Get.changeThemeMode(ThemeMode.system);
  } else if (darkMode == true) {
    Get.changeThemeMode(ThemeMode.dark);
  } else {
    Get.changeThemeMode(ThemeMode.light);
  }
}

void setDarkMode(Brightness brightness) async {
  var systemBrightness = SchedulerBinding.instance.window.platformBrightness;
  var prefs = await prefsFuture;
  if (brightness == systemBrightness) {
    Get.changeThemeMode(ThemeMode.system);
    prefs.remove("darkMode");
  } else if (brightness == Brightness.dark) {
    Get.changeThemeMode(ThemeMode.dark);
    prefs.setBool("darkMode", true);
  } else if (brightness == Brightness.light) {
    Get.changeThemeMode(ThemeMode.light);
    prefs.setBool("darkMode", false);
  }
}

void toggleDarkMode() async {
  if (Get.isDarkMode) {
    setDarkMode(Brightness.light);
  } else {
    setDarkMode(Brightness.dark);
  }
}
