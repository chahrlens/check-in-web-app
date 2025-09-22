import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF184E77);
  static const Color onPrimary = Color(0xFFF0F0F0);
  static const Color secondary = Colors.blueAccent;
  static const Color onSecondary = Color(0xFFF0F4FF);
  static const Color background = Color(0xFF1A1C1E);
  static const Color onBackground = Color(0xFFF0F0F0);
  static const Color surface = Color(0xFF2C2E33);
  static const Color onSurface = Color(0xFFF0F0F0);
  static const Color error = Color(0xFFD77A61);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color shadow = Colors.white;
  static const Color bodyMedium = Color(0xFFA1A1AA);
  static const Color cursor = Colors.white60;
  static const Color warning = Color(0xFFFFC107);
}

//https://coolors.co/palette/d9ed92-b5e48c-99d98c-76c893-52b69a-34a0a4-168aad-1a759f-1e6091-184e77

// darkPastelTheme

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
    onError: AppColors.onError,
  ),
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(color: AppColors.onPrimary),
    bodyMedium: TextStyle(color: AppColors.bodyMedium),
  ),
  shadowColor: AppColors.shadow,
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      textStyle: const TextStyle(fontSize: 16, color: AppColors.onPrimary),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.onPrimary,
      textStyle: const TextStyle(fontSize: 16, color: AppColors.onPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.cursor,
  ),
);



// final ThemeData appTheme = ThemeData(
//   colorScheme: ColorScheme(
//     brightness: Brightness.light,
//     primary: Color(0xFF184E77),
//     primaryFixed: Color(0xFF1A759F),
//     onPrimary: Color(0xFF1E6091),
//     primaryContainer: Color(0xFF2b8dcc),
//     onPrimaryFixed: Color(0xFF76C893),
//     secondary: Color(0xFF34A0A4),
//     onSecondary: Colors.black,
//     // onSurfaceVariant: Colors.grey[200],
//     //background: Color(0xFFF5FAFF),
//     //onBackground: Color(0xFF212121),
//     onSecondaryFixed: Color(0xFFF2F8FD), //BASE 184E77
//     onSecondaryFixedVariant: Color(0xFFE4EFFA), //BASE 184E77
//     surfaceContainerHighest: Color(0xFF1E6091),
//     surface: Colors.white,
//     onSurface: Color(0xFF1f2421),
//     onTertiaryContainer: Colors.grey[200],
//     error: Color(0xFFd62828),
//     onError: Color(0xFFe63946), //ae2012 alternative
//   ),
//   useMaterial3: true,
//   scaffoldBackgroundColor: Color(0xFFF5FAFF),
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Color(0xFF184E77),
//     foregroundColor: Color(0xFFd4f3f1),
//     elevation: 0,
//   ),
//   textTheme: const TextTheme(
//     headlineSmall: TextStyle(color: Color(0xFF212121)),
//     bodyMedium: TextStyle(color: Color(0xFF616161)),
//   ),
// );


// final ThemeData appTheme = ThemeData(
//   colorScheme: const ColorScheme(
//     brightness: Brightness.light,
//     primary: Color(0xFF114358),              // Color principal
//     primaryContainer: Color(0xFFF1ECE7),      // Fondo suave (segundo complementario)
//     onPrimary: Color(0xFFFFFFFF),             // Texto sobre primary
//     secondary: Color(0xFFF2AA1F),             // Color complementario (resaltado, botones, alertas)
//     onSecondary: Color(0xFF090909),           // Texto sobre secundario
//     error: Color(0xFFD62828),                 // Error
//     onError: Color(0xFFFFFFFF),
//     // background: Color(0xFFF1ECE7),            // Fondo general
//     // onBackground: Color(0xFF090909),          // Texto sobre fondo
//     surface: Colors.white,                    // Superficies como tarjetas
//     onSurface: Color(0xFF090909),             // Texto sobre superficies
//   ),
//   useMaterial3: true,
//   scaffoldBackgroundColor: const Color(0xFFF1ECE7),
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Color(0xFF114358),
//     foregroundColor: Colors.white,
//     elevation: 0,
//   ),
//   textTheme: const TextTheme(
//     headlineSmall: TextStyle(color: Color(0xFF090909)),
//     bodyMedium: TextStyle(color: Color(0xFF333333)),
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Color(0xFFF2AA1F), // Botones resaltados
//       foregroundColor: Color(0xFF090909),
//     ),
//   ),
// );

