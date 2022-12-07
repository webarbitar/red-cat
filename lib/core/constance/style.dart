import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MaterialColor primaryColor = MaterialColor(
  _primaryColorValue,
  <int, Color>{
    50: Color(0xFFFCE4E5),
    100: Color(0xFFF8BABE),
    200: Color(0xFFF38D93),
    300: Color(0xFFEE5F67),
    400: Color(0xFFEA3C47),
    500: Color(_primaryColorValue),
    600: Color(0xFFE31722),
    700: Color(0xFFDF131C),
    800: Color(0xFFDB0F17),
    900: Color(0xFFD5080D),
  },
);
const int _primaryColorValue = 0xFFE61A26;

const MaterialColor primaryColorAccent = MaterialColor(
  _primaryColorAccentValue,
  <int, Color>{
    100: Color(0xFFFFFEFE),
    200: Color(_primaryColorAccentValue),
    400: Color(0xFFFF989A),
    700: Color(0xFFFF7F81),
  },
);
const int _primaryColorAccentValue = 0xFFFFCBCC;

const mainColorGray = Color(0xfffafafa);
const blackColorTitleBkg = Color(0xff202020);
const backgroundColor = Color.fromRGBO(246, 247, 251, 1);
const highlightColor = Color.fromRGBO(237, 238, 240, 1);
const highlightColor2 = Color.fromRGBO(241, 232, 232, 1);

const dropShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 16,
  spreadRadius: 0,
  color: Color.fromRGBO(0, 0, 0, .08),
);

const systemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: backgroundColor,
  systemNavigationBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarIconBrightness: Brightness.dark,
);
