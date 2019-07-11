import 'package:flutter/material.dart';
import 'package:notifier/models/list.dart';
import 'package:notifier/models/theme_model.dart';
import 'package:notifier/views/app.dart';

void main() async {
  await ThemeModel.loadPrefs();
  ListModel listModel = ListModel();
  await listModel.load();
  runApp(App(listModel: listModel));
}
