
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';


import 'package:curve/app/app.locator.dart';
import 'settings_viewmodel.dart';
import '../../../utilities/statusbar_util.dart';


class SettingsView extends StatelessWidget {
  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<SettingsViewModel>.reactive(

      //On Ready model once
      //fireOnModelReadyOnce: true,

      onModelReady: (model) => (){model.initializer();},

      viewModelBuilder: () => SettingsViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
              Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body:  Stack(
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SafeArea(bottom: false ,child: Container(height: 62,)),

                          //Content Goes Here
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'General',
                                    style:
                                    Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: size.width,
                                  //height: 200.0,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Theme.of(context).colorScheme.surface,

                                  ),

                                  child: Column(
                                    children: [
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  //(Provider.of<AppData>(context).pickupAddress != null)?
                                                  //Provider.of<AppData>(context).pickupAddress.placeName
                                                  'I spotted a Bug',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ), //Settings Inner row//Bug
                                      //Divider
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  'I have a Suggestion',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ),//Settings Inner row//Suggestion
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),//General
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Notification',
                                    style:
                                    Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: size.width,
                                  //height: 200.0,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Theme.of(context).colorScheme.surface,

                                  ),

                                  child: Column(
                                    children: [
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  //(Provider.of<AppData>(context).pickupAddress != null)?
                                                  //Provider.of<AppData>(context).pickupAddress.placeName
                                                  'I spotted a Bug',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ), //Settings Inner row//Bug//Divider
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  'I have a Suggestion',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ),//Settings Inner row//Suggestion
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),//Notifications
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Feedback',
                                    style:
                                    Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: size.width,
                                  //height: 200.0,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Theme.of(context).colorScheme.surface,
                                  ),

                                  child: Column(
                                    children: [
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  //(Provider.of<AppData>(context).pickupAddress != null)?
                                                  //Provider.of<AppData>(context).pickupAddress.placeName
                                                  'I spotted a Bug',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ), //Settings Inner row//Bug//Divider
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  'I have a Suggestion',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ),//Settings Inner row//Suggestion
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),//Feedback
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Support',
                                    style:
                                    Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: size.width,
                                  //height: 200.0,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Theme.of(context).colorScheme.surface,

                                  ),
                                  child: Column(
                                    children: [
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  //(Provider.of<AppData>(context).pickupAddress != null)?
                                                  //Provider.of<AppData>(context).pickupAddress.placeName
                                                  'I need help',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ), //Settings Inner row//Need Help//Divider
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  'I have a Safety Concern',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ),//Settings Inner row//Safety concern
                                      //Divider
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  'I have a Privacy Question',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ),//Settings Inner row//Privacy question
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),//Support
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'More Information',
                                    style:
                                    Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: size.width,
                                  //height: 200.0,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Theme.of(context).colorScheme.surface,

                                  ),

                                  child: Column(
                                    children: [
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  //(Provider.of<AppData>(context).pickupAddress != null)?
                                                  //Provider.of<AppData>(context).pickupAddress.placeName
                                                  'Privacy Policy',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ), //Settings Inner row//Privacy
                                      //Divider
                                      RawMaterialButton(
                                        onPressed: (){},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          height: 55,
                                          width: size.width * 0.88,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //SvgPicture.asset('assets/icons/homeicon.svg'),
                                              //SizedBox(width: 15),
                                              Container(
                                                child: Text(
                                                  'Terms',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SvgPicture.asset('assets/icons/arrowforward.svg'),
                                            ],
                                          ),
                                        ),
                                      ),//Settings Inner row//Terms
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),//More Information
                          SizedBox(height: 20,),

                          //Sign out button
                          Container(
                            height: 45,
                            width: size.width * 0.88,
                            margin: EdgeInsets.only(
                                left: size.width * 0.06,
                                right: size.width * 0.06),

                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),

                              ),
                              onPressed: () async{

                                //Dispose shared pref
                                model.logoutConfirmation();

                                print('SIGNED OUT');


                              },

                              child: Text(
                                'SIGN OUT',
                                style:
                                Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                              ),
                            ),

                          ),

                          SizedBox(height: 20,),
                          SafeArea(top: false,bottom: true, child: Container(height: 0,)),
                        ],
                      ),
                    ),


                    //Blur App Bar
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        //color: ViellyThemeColor_whiteBack,
                      ),
                      child:
                      ClipRRect(
                        child: BackdropFilter(
                          filter:
                          ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            color: Theme.of(context).colorScheme.background.withOpacity(0.7),
                            child:
                            SafeArea(
                              bottom: false,
                              child: Container(
                                height: 52,
                                width: size.width,
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  //color: ViellyThemeColor_whiteBack,
                                ),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: size.width * 0.05),
                                      height: 47,
                                      width: 47,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        shape: CircleBorder(),
                                        child: SvgPicture.asset(
                                            'assets/icons/icon-arrow-back-black.svg',
                                          color: Theme.of(context).colorScheme.onSurface,),
                                        padding: EdgeInsets.all(2.0),
//fillColor: XDColor_white,
                                        elevation: 0,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Settings',
                                        style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                    ),//Page Header text
                                    Container(
                                      margin: EdgeInsets.only(right: size.width * 0.05),
                                      height: 47,
                                      width: 47,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),//App Bar
                      ),
                    ),//App Bar
                  ],
                ),
              )
          ),
    );
  }
}

