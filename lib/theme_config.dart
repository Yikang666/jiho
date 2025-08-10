import 'package:flutter/material.dart';

// 主题配置类
class ThemeConfig {
  // 主色调 - 莫奈风格柔和蓝
  static const primaryColor = Color(0xFF88A0A8);
  static const primaryLightColor = Color(0xFFB4C7CC);
  static const primaryDarkColor = Color(0xFF5A6D73);

  // 辅助色 - 莫奈风格紫粉色
  static const accentColor = Color(0xFFC9A9A6);
  static const accentLightColor = Color(0xFFE8D3D0);
  static const accentDarkColor = Color(0xFF9D7F7C);

  // 中性色 - 莫奈风格柔和灰
  static const backgroundColor = Color(0xFFF7F5F2);
  static const surfaceColor = Color(0xFFFAF8F5);
  static const errorColor = Color(0xFFD96060);

  // 文本颜色 - 莫奈风格自然色
  static const textPrimaryColor = Color(0xFF3A3A3A);
  static const textSecondaryColor = Color(0xFF6D6D6D);
  static const textOnPrimaryColor = Colors.white;
  static const textOnAccentColor = Colors.white;

  // 字体
  static const fontFamily = 'Roboto';

  // 主主题
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    primarySwatch: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    fontFamily: fontFamily,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      titleTextStyle: TextStyle(
        color: textOnPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: textOnPrimaryColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondaryColor,
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      elevation: 8.0,
    ),
  );

  // 暗黑主题
  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryDarkColor,
    primarySwatch: Colors.blue,
    colorScheme: ColorScheme.dark(
      primary: primaryDarkColor,
      secondary: accentDarkColor,
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      error: errorColor,
    ),
    fontFamily: fontFamily,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryDarkColor,
      titleTextStyle: TextStyle(
        color: textOnPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: textOnPrimaryColor),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryLightColor,
      unselectedItemColor: textSecondaryColor,
      backgroundColor: Color(0xFF1E1E1E),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      elevation: 8.0,
    ),
  );
}