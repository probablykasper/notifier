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
}

Globals globals = Globals();
