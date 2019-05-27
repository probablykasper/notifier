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
      theme: ThemeData(
        fontFamily: 'Jost',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        textSelectionColor: Colors.white24,
        textSelectionHandleColor: Globals.blue,
        accentColor: Colors.white,
        toggleableActiveColor: Globals.blue,
      ),
      home: ListPage(),
    );
  }
}
