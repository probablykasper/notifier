import 'package:flutter/material.dart';
import 'package:notifier/models/theme_model.dart';
import 'package:notifier/pages/list.dart';
import 'package:scoped_model/scoped_model.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ThemeModel>(
      model: ThemeModel(),
      child: ScopedModelDescendant<ThemeModel>(
        builder: (context, child, themeModel) {
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
