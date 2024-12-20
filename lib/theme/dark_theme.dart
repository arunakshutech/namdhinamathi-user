import 'dart:io';
import 'package:flutter/material.dart';
import '../configs/app_config.dart';
import 'text_themes.dart';
// import '../configs/font_config.dart';
// import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  // fontFamily: GoogleFonts.getFont(fontFamily).fontFamily,
  cardColor: const Color.fromARGB(255, 50, 50, 50), //tile color
  // canvasColor: Colors.grey.shade100, // body color of home and some particular screen
  textTheme: Platform.isIOS ? textThemeiOS : textThemeDefault,
  primaryColor: AppConfig.appThemeColor,
  dividerTheme: DividerThemeData(color: Colors.blueGrey.shade900),
);
