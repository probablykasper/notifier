import 'package:flutter/material.dart'
    show ThemeData, ThemeMode, WidgetsFlutterBinding, runApp;
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
  if (darkMode == true) {
    Get.changeTheme(getTheme(true));
  } else {
    Get.changeTheme(getTheme(false));
  }
}
