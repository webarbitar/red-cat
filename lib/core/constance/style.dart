import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MaterialColor primaryColor = MaterialColor(
  _primaryColorValue,
  <int, Color>{
    50: Color(0xFFF5E1E3),
    100: Color(0xFFE6B5BA),
    200: Color(0xFFD5848C),
    300: Color(0xFFC4525E),
    400: Color(0xFFB82D3C),
    500: Color(_primaryColorValue),
    600: Color(0xFFA40716),
    700: Color(0xFF9A0612),
    800: Color(0xFF91040E),
    900: Color(0xFF800208),
  },
);
const int _primaryColorValue = 0xFFAB0819;

const MaterialColor primaryColorAccent = MaterialColor(
  _primaryColorAccentValue,
  <int, Color>{
    100: Color(0xFFFFADAF),
    200: Color(_primaryColorAccentValue),
    400: Color(0xFFFF474B),
    700: Color(0xFFFF2E31),
  },
);
const int _primaryColorAccentValue = 0xFFFF7A7D;

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
