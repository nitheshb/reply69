import 'package:flutter/material.dart';

class Bid365AppTheme {
  Bid365AppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color nearlyBlue = Color(0xFF00B6F0);

  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color light_grey =   Color(0xFFEFF1F4);
  // static const Color p_green = Color(0xff00ff87);
  static const Color p_purple = Color(0xff37003C);
  // static const Color nearlyGreen = Color(0xff00ff87);
  static const Color nearlyRed = Color(0xffe90053);
  static const Color womenBg = Color(0xffF0AEAF);
  static const Color lightBg = Color(0xFFEFEFEF);

  // static const Color p_green = Color(0xffFF005A);
  // static const Color nearlyGreen = Color(0xffFF005A);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color p_green = Color(0xff00ff87);
  static const Color nearlyGreen = Color(0xff00ff87);
  // static const Color nearlyBlack = Color(0xFFefefef);
  
  static const Color gradient0 = Color(0xffFFB397); 
  static const Color gradient1 = Color(0xffF46AA0);

  // status bar color
  static const Color transparentbg = Color(0xffefefef);

  



  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF3a416f);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);

  static const TextTheme textTheme = TextTheme(
    display1: display1,
    headline: headline,
    title: title,
    subtitle: subtitle,
    body2: body2,
    body1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle( // h4 -> display1
    fontFamily: 'InterM',
    fontWeight: FontWeight.bold,
    fontSize: 26,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle( // h5 -> headline
    fontFamily: 'InterM',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle( // h6 -> title
    fontFamily: 'InterM',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
    fontFamily: 'InterM',
    fontWeight: FontWeight.w400,
    fontSize: 18,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle( // body1 -> body2
    fontFamily: 'InterM',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle( // body2 -> body1
    fontFamily: 'InterM',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle( // Caption -> caption
    fontFamily: 'InterM',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static const TextStyle teamTitle = TextStyle( // Caption -> caption
    fontFamily: 'InterM',
    fontWeight: FontWeight.bold,
    fontSize: 12,
    letterSpacing: 0.2,
    color: nearlyBlack, // was lightText
  );
   static const TextStyle tabHeader= TextStyle( // Caption -> caption
    fontSize: 14.0,
    fontFamily: 'InterM',
    fontWeight: FontWeight.bold, // was lightText
  );
  static const TextStyle subTitle1= TextStyle( // Caption -> caption
    fontWeight: FontWeight.w200,
    fontFamily: 'InterM',
    fontSize: 12,
    // letterSpacing: 0.27,
     color: grey,// was lightText
  );
   static const TextStyle subTitle2= TextStyle( // Caption -> caption
    fontWeight: FontWeight.w200,
    fontFamily: 'InterM',
    fontSize: 14,
    // letterSpacing: 0.27,
     color: nearlyBlack,// was lightText
  );
  static const TextStyle value= TextStyle( // Caption -> caption
    fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color:nearlyBlack,// was lightText
                                                          fontFamily: 'InterM',
  );
  static const TextStyle money= TextStyle( 
    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    letterSpacing: 0.27,
                                                    color: nearlyBlack,
                                                    fontFamily: 'InterM',
                                                        
  );

}
