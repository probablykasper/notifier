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
        scaffoldBackgroundColor: Globals.backgroundColor,
        textSelectionColor: Colors.white24,
        textSelectionHandleColor: Globals.blue,
        accentColor: Colors.white,
        toggleableActiveColor: Globals.blue,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey[900],
        ),
        buttonColor: Colors.yellowAccent,
        buttonTheme: ButtonThemeData(
          minWidth: 85,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      home: ListPage(),
    );
  }
}
