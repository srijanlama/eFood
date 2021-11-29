import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/utill/color_resources.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';

ThemeData light = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.light,
  scaffoldBackgroundColor: ColorResources.COLOR_PRIMARY,
  hintColor: Colors.grey,
  primaryColorLight: ColorResources.COLOR_PRIMARY,
  canvasColor: ColorResources.COLOR_PRIMARY,

  shadowColor: Color(0xfffcf9f4),
  backgroundColor: Color(0xffF4F7FC), // for background color
  cardColor: Color(0xFFFFFFFF), // for surface color
  primaryColor: Color(0xFFFC6A57), // for primary color
  highlightColor: Color(0xFF1F1F1F), // for on background text
  focusColor: Color(0xFF1F1F1F),  // for On Surface text color
  dividerColor: Color(0xFF2A2A2A), // for Any line
  errorColor: Color(0xFFFC6A57),  // for error color
  primaryColorDark: Color(0xFFFFFFFF),  // for on primary color

  textTheme: TextTheme(
    button: TextStyle(color: Colors.white),

    headline1: TextStyle(fontWeight: FontWeight.w300, color: ColorResources.COLOR_BLACK, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline2: TextStyle(fontWeight: FontWeight.w400, color: ColorResources.COLOR_BLACK, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline3: TextStyle(fontWeight: FontWeight.w500, color: ColorResources.COLOR_BLACK, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline4: TextStyle(fontWeight: FontWeight.w600, color: ColorResources.COLOR_BLACK, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline5: TextStyle(fontWeight: FontWeight.w700, color: ColorResources.COLOR_BLACK, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline6: TextStyle(fontWeight: FontWeight.w800, color: ColorResources.COLOR_BLACK, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    caption: TextStyle(fontWeight: FontWeight.w900, color: ColorResources.COLOR_BLACK, fontSize: Dimensions.FONT_SIZE_DEFAULT),



    subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
    bodyText2: TextStyle(fontSize: 12.0),
    bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
  ),
);