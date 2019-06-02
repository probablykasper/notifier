import 'package:flutter/material.dart';

class Globals {
  // Globals._();
  Globals();
  // static const <int, Color> grey = <int, Color>{
  //   1: Color(0xFF121212),
  // }
  Map<int, Color> get grey => <int, Color>{
        1: Color(0xFF121212),
        2: Color(0xFF202124),
        3: Color(0xFF313234),
        4: Color(0xFF43454c),
        5: Color(0xFF54565f),
        6: Color(0xFF676974),
      };

  Color get blue => Color(0xFF000B0FF);
  Color get backgroundColor => grey[1];
  Color get splashColor => grey[6].withOpacity(0.3);
  Color get highlightColor => grey[6].withOpacity(0.3);
  Color get appBarBackgroundColor => grey[2];
  TextStyle get appTitleStyle => TextStyle(
        color: blue,
      );
  TextStyle get buttonTextStyle => TextStyle(
        fontWeight: FontWeight.w600,
      );

  Color get primaryButtonColor => grey[4];
  Color get primaryButtonTextColor => Colors.white;

  ThemeData get appTheme => ThemeData(
        fontFamily: 'Jost',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: globals.backgroundColor,
        textSelectionColor: Colors.white24,
        textSelectionHandleColor: globals.blue,
        accentColor: Colors.white,
        toggleableActiveColor: globals.blue,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: globals.grey[3],
        ),
        buttonColor: Colors.yellowAccent,
        highlightColor: globals.highlightColor,
        splashColor: globals.splashColor,
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
          backgroundColor: globals.grey[2],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );

  ThemeData get pickerTheme => ThemeData(
        accentColor: Colors.blue,
        brightness: Brightness.dark,
        backgroundColor: globals.grey[3],
        dialogBackgroundColor: globals.grey[2],
        primaryColor: Colors.red,
        canvasColor: Colors.red,
        cardColor: Colors.red,
        highlightColor: Colors.red,
        splashColor: Colors.red,
        scaffoldBackgroundColor: Colors.red,
        buttonColor: Colors.red,
        secondaryHeaderColor: Colors.red,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red,
          splashColor: Colors.transparent,
        ),
        textTheme: TextTheme(
          button: TextStyle(
            color: Colors.red,
          ),
        ),
      );
}

Globals globals = Globals();
