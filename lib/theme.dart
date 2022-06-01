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
        TextStyle,
        TextTheme,
        ThemeData,
        ThemeMode;
import 'package:get/get.dart' show Get, GetNavigation;
import 'main.dart' show prefsFuture;

void initializeTheme() async {
  var prefs = await prefsFuture;
  var darkMode = prefs.getBool("darkMode");
  if (darkMode == null) {
    Get.changeThemeMode(ThemeMode.system);
  } else if (darkMode == true) {
    Get.changeThemeMode(ThemeMode.dark);
  } else {
    Get.changeThemeMode(ThemeMode.light);
  }
}

void setDarkMode(Brightness brightness) async {
  var systemBrightness = Get.mediaQuery.platformBrightness;
  var prefs = await prefsFuture;
  if (brightness == systemBrightness) {
    Get.changeThemeMode(ThemeMode.system);
    prefs.remove("darkMode");
  } else if (brightness == Brightness.dark) {
    Get.changeThemeMode(ThemeMode.dark);
    prefs.setBool("darkMode", true);
  } else if (brightness == Brightness.light) {
    Get.changeThemeMode(ThemeMode.light);
    prefs.setBool("darkMode", false);
  }
}

void toggleDarkMode() async {
  if (Get.isDarkMode) {
    setDarkMode(Brightness.light);
  } else {
    setDarkMode(Brightness.dark);
  }
}

class ThemedGray {
  final Color c1;
  final Color c2;
  final Color c3;
  final Color c4;
  final Color c5;
  final Color c6;
  final Color c7;
  final Color c8;
  final Color c9;
  const ThemedGray({
    required this.c1,
    required this.c2,
    required this.c3,
    required this.c4,
    required this.c5,
    required this.c6,
    required this.c7,
    required this.c8,
    required this.c9,
  });
}

const white = ThemedGray(
  c1: Color(0xFFF5F5F5),
  c2: Color(0xFFEEEEEE),
  c3: Color(0xFFE0E0E0),
  c4: Color(0xFFBDBDBD),
  c5: Color(0xFF9E9E9E),
  c6: Color(0xFF757575),
  c7: Color(0xFF616161),
  c8: Color(0xFF424242),
  c9: Color(0xFF212121),
);
const grey = ThemedGray(
  c1: Color(0xFF121212),
  c2: Color(0xFF202124),
  c3: Color(0xFF313234),
  c4: Color(0xFF43454c),
  c5: Color(0xFF54565f),
  c6: Color(0xFF676974),
  c7: Color(0xFF9E9E9E),
  c8: Color(0xFFBDBDBD),
  c9: Color(0xFFF5F5F5),
);
const blue = Color(0xFF00B0FF);

ThemeData getTheme(bool darkMode) {
  var color = darkMode ? grey : white;

  // final ColorScheme colorSchema;
  // if (darkMode) {
  //   colorSchema = const ColorScheme.dark();
  // } else {
  //   colorSchema = const ColorScheme.light();
  // }
  return ThemeData(
    fontFamily: 'Jost',
    brightness: darkMode ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: color.c1,
    toggleableActiveColor: blue,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: darkMode ? color.c3 : blue,
    ),
    textTheme: TextTheme(
      subtitle1: TextStyle(
        fontFamily: 'Jost',
        color: darkMode ? Colors.white : Colors.black,
      ),
    ),
    highlightColor:
        darkMode ? color.c6.withOpacity(0.3) : color.c6.withOpacity(0.2),
    splashColor: color.c6.withOpacity(0.3),
    primaryColor: Colors.white,
    // colorScheme: colorSchema.copyWith(
    //   secondary: Colors.blue,
    // ),
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
      backgroundColor: darkMode ? color.c2 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

class CustomThemeData {
  Color? textColor;
  Color? appBarBackgroundColor;
  Color? descriptionColor;
  Color? primaryButtonColor;
  Color? primaryButtonDisabledColor = white.c4.withOpacity(0.5);
  TextStyle? appTitleStyle;

  CustomThemeData light() {
    textColor = Colors.black;
    appBarBackgroundColor = blue;
    descriptionColor = white.c6;
    primaryButtonColor = blue;
    appTitleStyle = const TextStyle(color: Colors.white);
    return this;
  }

  CustomThemeData dark() {
    textColor = Colors.white;
    appBarBackgroundColor = grey.c2;
    descriptionColor = grey.c6;
    primaryButtonColor = grey.c4;
    appTitleStyle = const TextStyle(color: blue);
    return this;
  }
}

extension CustomTheme on ThemeData {
  CustomThemeData get custom => brightness == Brightness.dark
      ? CustomThemeData().dark()
      : CustomThemeData().light();
}
