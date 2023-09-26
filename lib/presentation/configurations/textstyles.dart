import 'package:flutter/material.dart';
import 'colors.dart';

const String fontFamily = "DIN Next Rounded LT W04";

const FontWeight light = FontWeight.w300;
const FontWeight normal = FontWeight.w600;
const FontWeight bold = FontWeight.w800;

//TEXT THEME
final TextTheme lightTextTheme = TextTheme(
  headline1: ThemeText_Heading_1.apply(color: ThemeColor_lightTextShade1),
  headline2: ThemeText_Heading_2.apply(color: ThemeColor_lightTextShade1),
  headline3: ThemeText_Heading_3.apply(color: ThemeColor_lightTextShade1),
  headline4: ThemeText_Heading_4.apply(color: ThemeColor_lightTextShade1),
  headline5: ThemeText_Heading_5.apply(color: ThemeColor_lightTextShade1),
  headline6: ThemeText_Heading_6.apply(color: ThemeColor_lightTextShade1),
  subtitle1: ThemeText_SubTitle_1.apply(color: ThemeColor_lightTextShade3),
  subtitle2: ThemeText_SubTitle_2.apply(color: ThemeColor_lightTextShade2),
  bodyText1: ThemeText_BodyText_1.apply(color: ThemeColor_lightTextShade1),
  bodyText2: ThemeText_BodyText_2.apply(color: ThemeColor_lightTextShade1),
  button: ThemeText_Button.apply(color: ThemeLightColor_background),
  caption: ThemeText_Caption.apply(color: ThemeColor_lightTextShade1),
  overline: ThemeText_Overline.apply(color: ThemeColor_lightTextShade1),
);

final TextTheme darkTextTheme = TextTheme(
  headline1: ThemeText_Heading_1.apply(color: ThemeColor_darkTextShade1),
  headline2: ThemeText_Heading_2.apply(color: ThemeColor_darkTextShade1),
  headline3: ThemeText_Heading_3.apply(color: ThemeColor_darkTextShade1),
  headline4: ThemeText_Heading_4.apply(color: ThemeColor_darkTextShade1),
  headline5: ThemeText_Heading_5.apply(color: ThemeColor_darkTextShade1),
  headline6: ThemeText_Heading_6.apply(color: ThemeColor_darkTextShade1),
  subtitle1: ThemeText_SubTitle_1.apply(color: ThemeColor_darkTextShade3),
  subtitle2: ThemeText_SubTitle_2.apply(color: ThemeColor_darkTextShade2),
  bodyText1: ThemeText_BodyText_1.apply(color: ThemeColor_darkTextShade1),
  bodyText2: ThemeText_BodyText_2.apply(color: ThemeColor_darkTextShade1),
  button: ThemeText_Button.apply(color: ThemeDarkColor_background),
  caption: ThemeText_Caption.apply(color: ThemeColor_darkTextShade1),
  overline: ThemeText_Overline.apply(color: ThemeColor_darkTextShade1),
);



//TEXTSTYLES
const ThemeText_Heading = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: light,
  fontSize: 96,
  letterSpacing: -1.5,
);//

const ThemeText_Heading_1 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: light,
  fontSize: 96,
  letterSpacing: -1.5,
);//

const ThemeText_Heading_2 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: light,
  fontSize: 60,
  letterSpacing: 0.5,
);//

const ThemeText_Heading_3 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: normal,
  fontSize: 48,
  letterSpacing: 0,
);//

const ThemeText_Heading_4 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: normal,
  fontSize: 34,
  letterSpacing: 0.25,
);//

const ThemeText_Heading_5 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: bold,
  fontSize: 26,
  letterSpacing: 0,
);//

const ThemeText_Heading_6 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: bold,
  fontSize: 20,
  letterSpacing: 0.15,
);//

const ThemeText_SubTitle_1 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: normal,
  fontSize: 16,
  letterSpacing: 0.15,
);//

const ThemeText_SubTitle_2 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: bold,
  fontSize: 14,
  letterSpacing: 0.1,
);//

const ThemeText_BodyText_1 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: normal,
  fontSize: 18,
  letterSpacing: 0.5,
);//

const ThemeText_BodyText_2 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: normal,
  fontSize: 16,
  letterSpacing: 0.25,
);//

const ThemeText_Button = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: bold,
  fontSize: 18,
  letterSpacing: 2,

);//CAPS

const ThemeText_Caption = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: normal,
  fontSize: 14,
  letterSpacing: 0.4,
);//CAPS

const ThemeText_Overline = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: normal,
  fontSize: 12,
  letterSpacing: 1.25,
);//



const ThemeText_Bold_60 = const TextStyle(
  fontFamily: fontFamily,
  fontWeight: bold,
  fontSize: 70,
  letterSpacing: 0.5,
);//