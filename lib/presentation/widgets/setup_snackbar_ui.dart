import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get/get.dart';


import '../configurations/colors.dart';
import '../../app/app.locator.dart';

enum SnackbarType { greyAlert, message, redAlert, greenAlert, greenInternet, redInternet}

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.greyAlert,
    config: SnackbarConfig(
      backgroundColor: ThemeColor_grey,
      titleColor: Colors.white,
      messageColor: Colors.white,
      titleTextAlign: TextAlign.center,
      messageTextAlign: TextAlign.center,
      maxWidth: 400,
      borderRadius: 15,
      dismissDirection: SnackDismissDirection.VERTICAL,
      snackPosition: SnackPosition.TOP,
      //animationDuration: Duration(seconds: 1),
      /*
      icon: Container(
        height: 18,
        width: 18,
        child: SvgPicture.asset('assets/icons/exclamation.svg', color: Colors.white),
      ),

       */
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),

    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.greenAlert,
    config: SnackbarConfig(
      backgroundColor: ThemeColor_green,
      titleColor: Colors.white,
      messageColor: Colors.white,
      titleTextAlign: TextAlign.center,
      messageTextAlign: TextAlign.center,
      maxWidth: 400,
      borderRadius: 15,
      dismissDirection: SnackDismissDirection.VERTICAL,
      snackPosition: SnackPosition.TOP,
      //animationDuration: Duration(seconds: 1),
      /*
      icon: Container(
        height: 18,
        width: 18,
        child: SvgPicture.asset('assets/icons/check.svg', color: Colors.white),
      ),

       */
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.redAlert,
    config: SnackbarConfig(
      backgroundColor: ThemeColor_red,
      titleColor: Colors.white,
      messageColor: Colors.white,
      messageTextAlign: TextAlign.center,
      maxWidth: 400,
      borderRadius: 15,
      dismissDirection: SnackDismissDirection.VERTICAL,
      snackPosition: SnackPosition.TOP,
      //animationDuration: Duration(seconds: 1),
      /*
      icon: Container(
        height: 18,
        width: 18,
        padding: EdgeInsets.only(left: 3),
        child: SvgPicture.asset('assets/icons/exclamation.svg', color: Colors.white),
      ),

       */
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      margin: EdgeInsets.all(10),
    ),
  );





  service.registerCustomSnackbarConfig(
    variant: SnackbarType.redInternet,
    config: SnackbarConfig(
        messageTextAlign: TextAlign.center,
        titleTextAlign: TextAlign.center,
        snackPosition: SnackPosition.TOP,
        backgroundColor: ThemeColor_red,
        padding: EdgeInsets.symmetric(
          vertical: 4,
        ),
        barBlur: 0,
        maxWidth: double.infinity,
        snackStyle: SnackStyle.GROUNDED,
        borderRadius: 0.0
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.greenInternet,
    config: SnackbarConfig(
        messageTextAlign: TextAlign.center,
        titleTextAlign: TextAlign.center,
        snackPosition: SnackPosition.TOP,
        backgroundColor: ThemeColor_green,
        padding: EdgeInsets.symmetric(
          vertical: 4,
        ),
        barBlur: 0,
        maxWidth: double.infinity,
        snackStyle: SnackStyle.GROUNDED,
        borderRadius: 0.0
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.message,
    config: SnackbarConfig(
      backgroundColor: Colors.grey,
      titleColor: Colors.white,
      messageColor: Colors.red,
      borderRadius: 1,
    ),
  );
}

