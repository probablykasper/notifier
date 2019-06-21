import 'package:flutter/material.dart';
import 'package:notifier/pages/app.dart';

import 'models/theme_model.dart';

void main() async {
  await ThemeModel.loadPrefs();
  runApp(App());
}
