import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
// loadPrefs() async {
//   prefs = await SharedPreferences.getInstance();
//   print('prefs loaded');
// }

class ThemeModel extends Model {
  bool _darkMode = true;
  bool get darkMode => _darkMode;

  TextStyle get appTitleStyle => TextStyle(
        color: darkMode ? blue : Colors.white,
      );
  TextStyle get buttonTextStyle => TextStyle(
        fontWeight: FontWeight.w600,
      );

  Map<int, Color> get grey => <int, Color>{
        1: Color(0xFF121212),
        2: Color(0xFF202124),
        3: Color(0xFF313234),
        4: Color(0xFF43454c),
        5: Color(0xFF54565f),
        6: Color(0xFF676974),
      };
  Map<int, Color> get white => <int, Color>{
        1: Colors.grey[100],
        2: Colors.grey[200],
        3: Colors.grey[300],
        4: Colors.grey[400],
        5: Colors.grey[500],
        6: Colors.grey[600],
      };
  Map<int, Color> color;
  Color textColor, backgroundColor, splashColor, highlightColor, appBarBackgroundColor, descriptionColor, primaryButtonColor, primaryButtonDisabledColor, errorText;
  Color get blue => Color(0xFF000B0FF);

  ThemeData appTheme;
  ThemeData pickerTheme;

  static loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print('prefs loaded');
  }

  ThemeModel() {
    bool darkModePreference = prefs.getBool('darkMode') ?? true;
    _setDarkMode(darkMode: darkModePreference);
  }

  toggleDarkMode() async {
    prefs.setBool('darkMode', !_darkMode);
    _setDarkMode(darkMode: !_darkMode);
    notifyListeners();
  }

  void _setDarkMode({bool darkMode}) {
    _darkMode = darkMode;
    print('[notifier] darkMode set to $darkMode');

    color = darkMode ? grey : white;
    textColor = darkMode ? Colors.white : Colors.black;
    errorText = Colors.red[400];
    backgroundColor = color[1];
    descriptionColor = color[6];
    primaryButtonColor = darkMode ? color[4] : blue;
    primaryButtonDisabledColor = color[4].withOpacity(0.5);
    splashColor = color[6].withOpacity(0.3);
    highlightColor = color[6].withOpacity(0.32);
    appBarBackgroundColor = darkMode ? color[2] : blue;

    appTheme = ThemeData(
      fontFamily: 'Jost',
      brightness: darkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      textSelectionColor: Colors.white24,
      textSelectionHandleColor: blue,
      accentColor: Colors.white,
      toggleableActiveColor: blue,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: darkMode ? color[3] : blue,
      ),
      buttonColor: Colors.yellowAccent,
      highlightColor: highlightColor,
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

    pickerTheme = ThemeData(
      accentColor: Colors.blue,
      brightness: darkMode ? Brightness.dark : Brightness.light,
    );
  }
}
