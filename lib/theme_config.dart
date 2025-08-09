import 'package:flutter/material.dart';

// 主题配置类
class ThemeConfig {
  // 主色调
  static const primaryColor = Color(0xFF1E88E5);
  static const primaryLightColor = Color(0xFF64B5F6);
  static const primaryDarkColor = Color(0xFF0D47A1);

  // 辅助色
  static const accentColor = Color(0xFFFFA000);
  static const accentLightColor = Color(0xFFFFD740);
  static const accentDarkColor = Color(0xFFF57C00);

  // 中性色
  static const backgroundColor = Color(0xFFF5F5F5);
  static const surfaceColor = Colors.white;
  static const errorColor = Color(0xFFD32F2F);

  // 文本颜色
  static const textPrimaryColor = Color(0xFF212121);
  static const textSecondaryColor = Color(0xFF757575);
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
  );
}