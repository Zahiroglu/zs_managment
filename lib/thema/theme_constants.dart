import 'package:flutter/material.dart';

const Color notWhite = Color(0xFFEDF0F2);
const Color nearlyWhite = Color(0xFFFEFEFE);
const Color white = Color(0xFFFFFFFF);
const Color nearlyBlack = Color(0xFF213333);
const Color grey = Color(0xFF3A5160);
const Color dark_grey = Color(0xFF313A44);
const Color darkText = Color(0xFF253840);
const Color darkerText = Color(0xFF17262A);
const Color lightText = Color(0xFF4A6572);
const Color deactivatedText = Color(0xFF767676);
const Color dismissibleBackground = Color(0xFF364A54);
const Color chipBackground = Color(0xFFEEF1F3);
const Color spacer = Color(0xFFF2F2F2);
const String fontName = 'WorkSans';
const colorPramary = Colors.blueAccent;
const colorAccent = Colors.greenAccent;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: colorPramary,
  cardTheme: CardTheme(
    elevation: 10,
    color: Colors.white,
    shadowColor: Colors.black.withOpacity(0.2)
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: colorAccent),
  drawerTheme: const DrawerThemeData(elevation: 0, backgroundColor: Colors.black),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0))),
          backgroundColor: MaterialStateProperty.all<Color>(colorAccent))),
  inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(),
    bodyMedium: TextStyle(),
  ).apply(
    bodyColor: const Color(0xff22215B),
    displayColor:  const Color(0xff22215B),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardTheme: CardTheme(
      elevation: 10,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.2)
  ),
  drawerTheme: const DrawerThemeData(elevation: 0, backgroundColor: Colors.white),
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.all<Color>(Colors.grey),
    thumbColor: MaterialStateProperty.all<Color>(Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1)),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black26))),

);

//  const TextTheme textTheme = TextTheme(
//   headline4: display1,
//   headline5: headline,
//   headline6: title,
//   subtitle2: subtitle,
//   bodyText2: body2,
//   bodyText1: body1,
//   caption: caption,
// );
//
//  const TextStyle display1 = TextStyle( // h4 -> display1
//   fontFamily: fontName,
//   fontWeight: FontWeight.bold,
//   fontSize: 36,
//   letterSpacing: 0.4,
//   height: 0.9,
//   color: darkerText,
// );
//
//  const TextStyle headline = TextStyle( // h5 -> headline
//   fontFamily: fontName,
//   fontWeight: FontWeight.bold,
//   fontSize: 24,
//   letterSpacing: 0.27,
//   color: darkerText,
// );
//
//  const TextStyle title = TextStyle( // h6 -> title
//   fontFamily: fontName,
//   fontWeight: FontWeight.bold,
//   fontSize: 15,
//   letterSpacing: 0.18,
//   color: darkerText,
// );
//
//  const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
//   fontFamily: fontName,
//   fontWeight: FontWeight.w400,
//   fontSize: 14,
//   letterSpacing: -0.04,
//   color: darkText,
// );
//
//  const TextStyle body2 = TextStyle( // body1 -> body2
//   fontFamily: fontName,
//   fontWeight: FontWeight.w400,
//   fontSize: 14,
//   letterSpacing: 0.2,
//   color: darkText,
// );
//
//  const TextStyle body1 = TextStyle( // body2 -> body1
//   fontFamily: fontName,
//   fontWeight: FontWeight.w400,
//   fontSize: 16,
//   letterSpacing: -0.05,
//   color: darkText,
// );
//
//  const TextStyle caption = TextStyle( // Caption -> caption
//   fontFamily: fontName,
//   fontWeight: FontWeight.w400,
//   fontSize: 12,
//   letterSpacing: 0.2,
//   color: lightText, // was lightText
// );

const LinearGradient bacgroundgradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 0.0),
    colors: <Color>[Color(0xFF5791D5), Color(0xFF1DE9B6)]);
LinearGradient bacgroundgradientTransparentLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 0.0),
    colors: <Color>[
      Color(0xFFFFFFFF).withOpacity(0.2),
      Color(0xFFFFFFFF).withOpacity(0.2)
    ]);
LinearGradient bacgroundgradientTransparentDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 0.0),
    colors: <Color>[
      Color(0xFF3A5160).withOpacity(0.5),
      Color(0xFF3A5160).withOpacity(0.5)
    ]);
