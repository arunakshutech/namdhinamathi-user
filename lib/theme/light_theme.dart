import 'dart:io';
import 'package:flutter/material.dart';
import '../configs/app_config.dart';
import 'text_themes.dart';
// import '../configs/font_config.dart';
// import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: AppConfig.appThemeColor,
  textTheme: Platform.isIOS ? textThemeiOS : textThemeDefault,
  cardColor: Colors.white, //tile color
  canvasColor: Colors.grey.shade100, // body color of home and some particular screen
  secondaryHeaderColor: Colors.grey.shade300, //secondary tile color
  scaffoldBackgroundColor: Colors.white,
  // fontFamily: GoogleFonts.getFont(fontFamily).fontFamily,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  dividerTheme: DividerThemeData(color: Colors.blueGrey.shade100, thickness: 0.7),
);