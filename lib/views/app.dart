import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notifier/models/theme_model.dart';
import 'package:notifier/views/list.dart';
import 'package:scoped_model/scoped_model.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ThemeModel>(
      model: ThemeModel(),
      child: ScopedModelDescendant<ThemeModel>(
        builder: (context, child, themeModel) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, //status bar color
              statusBarIconBrightness: Brightness.light, //status bar icons
            ),
          );
          return MaterialApp(
            title: 'Notifier',
            debugShowCheckedModeBanner: false,
            theme: themeModel.appTheme,
            home: ListPage(),
          );
        },
      ),
    );
  }
}
