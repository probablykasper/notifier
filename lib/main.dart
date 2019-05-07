import 'package:flutter/material.dart';
import 'package:notifier/globals.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/models/list.dart';
import 'package:notifier/pages/list.dart';

void main() {
  final list = ListModel();
  runApp(ScopedModel<ListModel>(
    model: list,
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Rubik',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        splashColor: Colors.transparent,
        textSelectionColor: Colors.white24,
        textSelectionHandleColor: Globals.blue,
        accentColor: Colors.white,
      ),
      home: ListPage(),
    );
  }
}
