import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notifier/models/list.dart';
import 'package:notifier/models/theme_model.dart';
import 'package:notifier/views/app.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<void> checkIfRestored() async {
  ListModel listModel = ListModel();

  // If the last time BackgroundFetch ran was before the app was installed, we'll disable all notifications, because that means the app data was restored from a backup.
  await SharedPreferences.getInstance();
  int lastBackgroundFecthDateMSSE = prefs.getInt('lastBackgroundFetchDate') ?? 0;

  const platform = MethodChannel('space.kasper.notifier/get_install_date');
  String installDateMSSE = await platform.invokeMethod('get_install_date'); // MilliSecondsSinceEpoch
  if (int.parse(installDateMSSE) < lastBackgroundFecthDateMSSE) {
    listModel.disableAll();
  }
}

void main() async {
  await ThemeModel.loadPrefs();
  await checkIfRestored();
  runApp(App());
}
