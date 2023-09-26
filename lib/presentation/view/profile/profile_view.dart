import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../app/app.locator.dart';
import '../../../presentation/widgets/custom_widgets/button.dart';
import '../../../presentation/widgets/custom_widgets/paymentmethod_tile.dart';
import '../../../presentation/widgets/custom_widgets/button_white.dart';
import 'profile_viewmodel.dart';
import '../../../utilities/statusbar_util.dart';


class ProfileView extends StatelessWidget {

  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<ProfileViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,

      //On Ready model once
      fireOnModelReadyOnce: true,

      onModelReady: (model) => model.getProfileDetails(),

      viewModelBuilder: () => locator<ProfileViewModel>(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
              Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body:
                Stack(
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SafeArea(bottom: false,child: Container(height: 62,)),
                          //AvatarSide
                          /*
                          Container(
                            height: 200,
                            width: size.width,
                            child: Column(
                              children: [
                                //Avatar
                                OpenContainer <String>(
                                    closedColor: Colors.white,
                                    openColor: Colors.white,
                                    closedElevation: 0,
                                    openElevation: 0,
                                    transitionType:
                                    ContainerTransitionType.fade,
                                    transitionDuration:
                                    const Duration(milliseconds: 200),

                                    closedBuilder: (context, openContainer)  {
                                      return
                                        InkWell(
                                          child:
                                          Container(
                                            height: 130,
                                            width: 130,
                                            child: Stack(
                                              children: [

                                                Container(
                                                  height: 150,
                                                  width: 150,
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.all(Radius.circular(50.0)), //add border radius here
                                                      child:
                                                      //(sharedpref.getUserThumbnailPic() != "empty")
                                                         // ?
                                                      //Image.network()
                                                          //:
                                                      Image(image: AssetImage('assets/images/emptyprofile.png'), fit: BoxFit.fill)
                                                  ),
                                                ),

                                                Positioned(
                                                  right: 2,
                                                  bottom: 3,
                                                  child: Container(
                                                    width: 30.0,
                                                    height: 30.0,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Theme.of(context).colorScheme.primary,
                                                      border: Border.all(
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    child: SvgPicture.asset('assets/icons/edit_avatar.svg',),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                    },
                                    //openBuilder: (context, closeContainer){
                                     // return AvatarPage();
                                    //}
                                ),


                                SizedBox(height: 10,),

                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text(
                                          //(sharedpref.getUserName() != "empty")
                                             // ?
                                          //sharedpref.getUserName()
                                              //:
                                          "No Name",
                                          //style:
                                          //ViellyThemeText_Bold_GreyText_22,
                                        ),
                                      ),

                                      //Email
                                      Container(
                                        child: Text(
                                          //(sharedpref.getUserEmail() != "empty")
                                              //?
                                          //sharedpref.getUserEmail()
                                              //:
                                          "",
                                          //style: ViellyThemeText_Medium_Grey_17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                           */

                          Container(
                            height: 130,
                            width: 130,
                            child: Stack(
                              children: [

                                Container(
                                  height: 150,
                                  width: 150,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(50.0)), //add border radius here
                                      child:
                                          Container(
                                            child: (model.profileFile == null)
                                                ?
                                                Container(
                                                  child: (model.userProfile.originalImage == null)
                                                      ?
                                                  Image(image: AssetImage('assets/images/emptyprofile.png'), fit: BoxFit.fill)
                                                      :
                                                  CachedNetworkImage(
                                                    placeholder: (context, url) => SpinKitRing(lineWidth: 3,
                                                      color: Theme.of(context).colorScheme.primary,),
                                                    imageUrl: '${model.userProfile.originalImage}',
                                                    fit: BoxFit.fill,
                                                    fadeInCurve: Curves.easeIn,
                                                    fadeInDuration: Duration(milliseconds: 1000),
                                                    cacheManager: model.cacheManager,
                                                  )
                                                )
                                                :
                                            Image.file(model.profileFile)
                                          ),

                                  ),
                                ),

                                /*
                                Positioned(
                                  right: 2,
                                  bottom: 3,
                                  child: Container(
                                    width: 30.0,
                                    height: 30.0,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.primary,

                                    ),
                                    child: SvgPicture.asset('assets/icons/edit_avatar.svg',),
                                  ),
                                ),

                                 */
                              ],
                            ),
                          ),

                          SizedBox(height: 10,),

                          Container(
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    (model.userProfile.name != null)
                                        ?
                                    "${model.userProfile.name}"
                                        :
                                    "",
                                    style:
                                    Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),

                                //Email
                                Container(
                                  child: Text(
                                    (model.userProfile.email != null)
                                        ?
                                    "${model.userProfile.email}"
                                        :
                                    "",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //User Stats Profile
                          Container(
                            width: size.width,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              children: [
                                /*
                        Container(
                          width: size.width,
                          padding: EdgeInsets.symmetric(horizontal: size.width*0.06),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  //width: 150.0,
                                  height: 60.0,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: ViellyThemeColor_whiteBack,
                                    border: Border.all(
                                      width: 2.0,
                                      color: ViellyThemeColor_greyBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        color: Colors.black45,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                '234',
                                                style:
                                                ViellyThemeText_Bold_GreyText_20,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                'Followers',
                                                style:
                                                ViellyThemeText_Regular_GreySecond_18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  //width: 150.0,
                                  height: 60.0,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: ViellyThemeColor_whiteBack,
                                    border: Border.all(
                                      width: 2.0,
                                      color: ViellyThemeColor_greyBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        color: Colors.black45,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                '234',
                                                style:
                                                ViellyThemeText_Bold_GreyText_20,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                'Followers',
                                                style:
                                                ViellyThemeText_Regular_GreySecond_18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),//Row 1
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: size.width,
                          padding: EdgeInsets.symmetric(horizontal: size.width*0.06),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  //width: 150.0,
                                  height: 60.0,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: ViellyThemeColor_whiteBack,
                                    border: Border.all(
                                      width: 2.0,
                                      color: ViellyThemeColor_greyBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        color: Colors.black45,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                '234',
                                                style:
                                                ViellyThemeText_Bold_GreyText_20,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                'Followers',
                                                style:
                                                ViellyThemeText_Regular_GreySecond_18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  //width: 150.0,
                                  height: 60.0,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: ViellyThemeColor_whiteBack,
                                    border: Border.all(
                                      width: 2.0,
                                      color: ViellyThemeColor_greyBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        color: Colors.black45,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Text(
                                                '234',
                                                style:
                                                ViellyThemeText_Bold_GreyText_20,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                'Followers',
                                                style:
                                                ViellyThemeText_Regular_GreySecond_18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),//Row 2
                        */
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  width: size.width,
                                  child: Container(
                                    width: size.width * 0.88,
                                    margin: EdgeInsets.only(
                                        left: size.width * 0.06,
                                        right: size.width * 0.06),
                                    child:
                                    ButtonWhite(
                                      child:
                                      Row(
                                        mainAxisAlignment:  MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "UPDATE PROFILE",
                                            style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                                          ),
                                        ],
                                      ),
                                      size: 45,
                                      color: Theme.of(context).colorScheme.background,
                                      onPressed: () async{

                                        await model.navigateToEdit();
                                      },
                                    ),

                                  ),
                                ),//Button Edit Button
                              ],
                            ),
                          ),

                          SizedBox(height: 20,),

                          //Refer Friends
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.06,),
                            width: size.width,
                            //height: 150.0,
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: size.width*0.06,),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Theme.of(context).colorScheme.surface,
                            ),

                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Refer your friends',
                                    //style: ViellyThemeText_Bold_GreyTextSecond_18,
                                  ),
                                ),
                                SizedBox(height: 10,),

                                Container(
                                  child: Text(
                                   (model.userProfile.name != null)
                                        ?
                                   "${model.userProfile.referralCode}"
                                       :
                                    "NO CODE"
                                    ,
                                    //style: ViellyThemeText_Bold_GreyText_22,
                                  ),
                                ),


                                SizedBox(
                                  height: 20,
                                ),

                                Container(
                                  width: size.width,
                                  child: Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Text(
                                            "INVITE FRIENDS",
                                            style: Theme.of(context).textTheme.button,
                                          ),
                                        ),
                                      ],
                                    ),
                                    size: 50,
                                    color: Theme.of(context).colorScheme.primary,
                                    onPressed: () async{

                                      //model.showLoadingDialog('Loading', true);

                                      /*
                                      model.showDialogConfirm(
                                        title: 'Done',
                                        description: 'Very well done',
                                        mainTitle: 'DONE',
                                        secondTitle: 'CANCEL',
                                      );

                                       */

                                      //model.showBusNotStarted();

                                      //model.showDriverArrived();


                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20,),

                          //Saved Location
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.06,),
                            width: size.width,
                            //height: 150.0,
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: size.width*0.06,),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Theme.of(context).colorScheme.surface,

                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Saved Location',
                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),

                                  ),
                                ),
                                SizedBox(height: 15,),

                                //SAVED LOCATIONS
                                Container(

                                  child: Column(
                                    children: [
                                      //SAVED HOME
                                      (model.isHomeLocation != null)
                                        ?
                                      Container(
                                        height: 45,
                                        //color: ViellyThemeColor_whiteBack,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/homeicon.svg', color: Theme.of(context).colorScheme.primary,),
                                                  SizedBox(width: 15),
                                                  Container(
                                                    child: Text(
                                                      'Home',
                                                      style: Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onError),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //Add Button
                                            InkWell(
                                              onTap: (){
                                                model.navigateToEditHomeWork(isHome: true);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.onSurface,
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 12),
                                                height: 35,
                                                child: Center(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          height: 10,
                                                          width: 10,
                                                          child: SvgPicture.asset('assets/icons/cross-1.svg', color: Theme.of(context).colorScheme.background,)),
                                                      SizedBox(width: 3),
                                                      Text(
                                                          'EDIT', style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.background)
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ) //EDIT HOME
                                          :
                                      Container(
                                        height: 45,
                                        //color: ViellyThemeColor_whiteBack,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/homeicon.svg', color: Theme.of(context).colorScheme.onSurface,),
                                                  SizedBox(width: 15),
                                                  Container(
                                                    child: Text(
                                                      'Add Home',
                                                      style: Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //Add Button
                                            InkWell(
                                              onTap: (){
                                                model.navigateAddHomeWork(isHome: true);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 12),
                                                height: 35,
                                                child: Center(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          height: 10,
                                                          width: 10,
                                                          child: SvgPicture.asset('assets/icons/cross-1.svg', color: Theme.of(context).colorScheme.background,)),
                                                      SizedBox(width: 3),
                                                      Text(
                                                          'ADD', style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.background)
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ), //ADD HOME
                                      //Location row

                                      SizedBox(height: 5,), //Divider

                                      //SAVED WORK
                                      (model.isWorkLocation != null)
                                          ?
                                      Container(
                                        height: 45,
                                        //color: ViellyThemeColor_whiteBack,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/workicon.svg', color: Theme.of(context).colorScheme.primary,),
                                                  SizedBox(width: 15),
                                                  Container(
                                                    child: Text(
                                                      'Work',
                                                      style: Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onError),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //Add Button
                                            InkWell(
                                              onTap: (){
                                                model.navigateToEditHomeWork(isHome: false);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.onSurface,
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 12),
                                                height: 35,
                                                child: Center(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          height: 10,
                                                          width: 10,
                                                          child: SvgPicture.asset('assets/icons/cross-1.svg', color: Theme.of(context).colorScheme.background,)),
                                                      SizedBox(width: 3),
                                                      Text(
                                                          'EDIT', style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.background)
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ) //EDIT WORK
                                          : //Location row
                                      Container(
                                        height: 45,
                                        //color: ViellyThemeColor_whiteBack,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/workicon.svg', color: Theme.of(context).colorScheme.onSurface,),
                                                  SizedBox(width: 15),
                                                  Container(
                                                    child: Text(
                                                      'Add Work',
                                                      style: Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //Add Button
                                            InkWell(
                                              onTap: (){
                                                model.navigateAddHomeWork(isHome: false);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 12),
                                                height: 35,
                                                child: Center(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          height: 10,
                                                          width: 10,
                                                          child: SvgPicture.asset('assets/icons/cross-1.svg', color: Theme.of(context).colorScheme.background,)),
                                                      SizedBox(width: 3),
                                                      Text(
                                                          'ADD', style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.background)
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ), //ADD WORK
                                      SizedBox(height: 5,),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 10,),

                                //SEE SAVED LOCATION BUTTON
                                Container(
                                  width: size.width,
                                  child: Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Text(
                                            "SEE SAVED LOCATIONS",
                                            style: Theme.of(context).textTheme.button,
                                          ),
                                        ),
                                      ],
                                    ),
                                    size: 45,
                                    color: Theme.of(context).colorScheme.primary,
                                    onPressed: () {

                                      model.navigateToSavedLocation();

                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20,),

                          //PAYMENT
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.06,),
                            width: size.width,
                            //height: 150.0,
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: size.width*0.06,),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Theme.of(context).colorScheme.surface,

                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Default Payment',
                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                  ),
                                ),
                                SizedBox(height: 10,),

                                //Payment Tile
                                Container(
                                  child: PaymentMethodTile(
                                      paymentDefault: model.userDefaultPayment),
                                  ),

                                SizedBox(height: 20,),

                                Container(
                                  width: size.width,
                                  child: Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Text(
                                            "SEE PAYMENT METHODS",
                                            style: Theme.of(context).textTheme.button,
                                          ),
                                        ),
                                      ],
                                    ),
                                    size: 45,
                                    color: Theme.of(context).colorScheme.primary,
                                    onPressed: () {

                                      model.navigateToPaymentOpt();
                                    },
                                  ),
                                ),

                                ],
                              ),
                            ),//Locations

                          SizedBox(height: 20,),
                          SafeArea(top: false,bottom: true, child: Container(height: 0,)),

                        ],
                      ),
                    ),



                    //Blur App Bar
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: size.width * 0.05,right: size.width * 0.05),
                                      height: 45,
                                      width: 45,
                                      child: RawMaterialButton(
                                        onPressed: () async{
                                          await model.navigateToSettings();
                                        },
                                        shape: CircleBorder(),
                                        child: SvgPicture.asset(
                                            'assets/icons/settings.svg'),
                                        padding: EdgeInsets.all(2.0),
                                        //fillColor: XDColor_white,
                                        elevation: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),//App Bar
                      ),
                    ),
                    ],
                ),
              ),
          ),
    );
  }
}

