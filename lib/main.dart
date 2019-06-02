import 'package:flutter/material.dart';
import 'package:notifier/globals.dart';
import 'package:notifier/pages/list.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifier',
      debugShowCheckedModeBanner: false,
      theme: globals.appTheme,
      home: ListPage(),
    );
  }
}
