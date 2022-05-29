import 'package:flutter/material.dart'
    show
        BorderRadius,
        Brightness,
        ButtonThemeData,
        CardTheme,
        Color,
        Colors,
        DialogTheme,
        FloatingActionButtonThemeData,
        RoundedRectangleBorder,
        ThemeData;

ThemeData getTheme(bool darkMode) {
  var grey = {
    1: const Color(0xFF121212),
    2: const Color(0xFF202124),
    3: const Color(0xFF313234),
    4: const Color(0xFF43454c),
    5: const Color(0xFF54565f),
    6: const Color(0xFF676974),
    7: Colors.grey.shade500,
    8: Colors.grey.shade400,
    9: Colors.grey.shade100,
  };
  var white = {
    1: Colors.grey.shade100,
    2: Colors.grey.shade200,
    3: Colors.grey.shade300,
    4: Colors.grey.shade400,
    5: Colors.grey.shade500,
    6: Colors.grey.shade600,
    7: Colors.grey.shade700,
    8: Colors.grey.shade800,
    9: Colors.grey.shade900,
  };
  const blue = Color(0xFF00B0FF);
  var color = darkMode ? grey : white;

  var backgroundColor = color[1];
  var splashColor = color[6]?.withOpacity(0.3);

  return ThemeData(
    fontFamily: 'Jost',
    brightness: darkMode ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    // textSelectionColor: Colors.white24,
    // textSelectionHandleColor: blue,
    // accentColor: Colors.white,
    toggleableActiveColor: blue,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: darkMode ? color[3] : blue,
    ),
    // buttonColor: Colors.yellowAccent,
    highlightColor:
        darkMode ? color[6]?.withOpacity(0.3) : color[6]?.withOpacity(0.2),
    splashColor: splashColor,
    buttonTheme: ButtonThemeData(
      minWidth: 85,
      height: 35,
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
      backgroundColor: darkMode ? color[2] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}
