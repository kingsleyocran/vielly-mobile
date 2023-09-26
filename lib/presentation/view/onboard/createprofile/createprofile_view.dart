import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../presentation/configurations/colors.dart';
import '../../../../utilities/formvalidators_util.dart';
import '../../../widgets/custom_widgets/button.dart';
import 'createprofile_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';

class CreateProfileView extends StatefulWidget {



  @override
  _CreateProfileViewState createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //bool _visible;

  FocusNode lNameFocusNode = FocusNode();
  FocusNode fNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();


  final TextEditingController fnameController = TextEditingController();

  final TextEditingController lnameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  String? email;

  String? fname;

  String? lname;

  bool isEmailValid = false;

  bool isFNameValid = false;

  bool isLNameValid = false;




  @override
  void initState() {

    /*
    _visible = false;

    KeyboardVisibilityNotification().addNewListener(onChange: (bool visible) {

      setState(() {_visible = visible;});

    });

     */

    fnameController.text = '';
    fnameController.addListener(() {
      setState(() {}); // setState every time text changes
    });

    lnameController.text = '';
    lnameController.addListener(() {
      setState(() {}); // setState every time text changes
    });

    emailController.text = '';
    emailController.addListener(() {
      setState(() {}); // setState every time text changes
    });

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    lNameFocusNode.dispose();
    fNameFocusNode.dispose();
    emailFocusNode.dispose();

    fnameController.dispose();
    lnameController.dispose();
    emailController.dispose();

    super.dispose();
  }











  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<CreateProfileViewModel>.reactive(
      viewModelBuilder: () => CreateProfileViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body:
              GestureDetector(
                onTap: (){
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  height: size.height,
                  child: Stack(

                    children: [
                      //Content
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(

                          children: [
                            Column(
                              children: [
                                SafeArea(bottom: false,child: Container(height: 62,)),

                                //Content Goes Here
                                Container(
                                  height: 500,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      //Profile Image
                                      Container(
                                        width: size.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              onTap: () {

                                                model.showProfilePictureBottomSheet(context);
                                              },
                                              child: Container(
                                                height: 130,
                                                width: 130,
                                                child: Center(
                                                  child: Stack(
                                                    children: [


                                                      Container(
                                                        height: 110,
                                                        width: 110,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.all(Radius.circular(40.0)), //add border radius here
                                                            child:
                                                            (model.profilePath == '')
                                                                ?
                                                            Image(image: AssetImage('assets/images/emptyprofile.png'), fit: BoxFit.fill)
                                                                :
                                                            //Image.network(model.profilePath,fit: BoxFit.fill),
                                                          CachedNetworkImage(
                                                            placeholder: (context, url) => SpinKitRing(lineWidth: 3,
                                                              color: Theme.of(context).colorScheme.primary,),
                                                            imageUrl:
                                                            '${model.profilePath}',
                                                            fit: BoxFit.fill,
                                                            fadeInCurve: Curves.easeIn,
                                                            fadeInDuration: Duration(milliseconds: 1000),
                                                            cacheManager: model.cacheManager,
                                                          ),
                                                        ),
                                                      ),

                                                      AnimatedOpacity(
                                                        opacity: model.upLoadState == 'Uploading' ? 1.0 : 0.0,
                                                        duration: Duration(
                                                          seconds: 1,
                                                        ),
                                                        child:Container(
                                                          height: 110,
                                                          width: 110,
                                                          decoration: BoxDecoration(
                                                            color: Colors.black.withOpacity(0.5),
                                                            borderRadius: BorderRadius.all(Radius.circular(40.0)), //add border radius here
                                                          ),
                                                          child: Center(
                                                            child: Container(
                                                              height: 50,
                                                              width: 50,
                                                              child: SpinKitRing(
                                                                lineWidth: 3,
                                                                color: Theme.of(context).colorScheme.primary,),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      Positioned(
                                                        right: 0,
                                                        bottom: 2,
                                                        child: (model.upLoadState == 'Uploading')
                                                            ?
                                                        Container()
                                                            :
                                                        Container(
                                                          width: 30.0,
                                                          height: 30.0,
                                                          padding: EdgeInsets.all(7),
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Theme.of(context).colorScheme.primary,
                                                          ),
                                                          child: SvgPicture.asset('assets/icons/edit_avatar.svg',),
                                                        ),

                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 15,),

                                      //Please use your real name
                                      Container(
                                        width: size.width,
                                        margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.onError,
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(AppLocalizations.of(context)!.pleaseUseYourRealName,
                                                style:
                                                Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.background),
                                                ),
                                                SizedBox(width: 7,),
                                                Container(
                                                    height: 15,
                                                    width: 15,
                                                    child: SvgPicture.asset('assets/icons/exclamation-mark.svg', color: Theme.of(context).colorScheme.background,))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20,),

                                      //Profile Info
                                      Container(
                                        width: size.width,
                                        margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                                        child: Column(
                                          children: [
                                            //Entries First Name
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Container(
                                                    height: 20,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(context)!.firstName,
                                                          style:
                                                          Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          child: (fnameController.text != '' && isFNameValid)
                                                              ?
                                                          SvgPicture.asset('assets/icons/tick-mark.svg', color: ThemeColor_green,)
                                                              :
                                                          (fnameController.text != '')  ? SvgPicture.asset('assets/icons/tick-cancel.svg', color: ThemeColor_red,) : Container()

                                                          ,
                                                        ),
                                                        ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 50,
                                                          padding: EdgeInsets.only(
                                                            left: 14,
                                                            right: 14,
                                                            bottom: 0,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).colorScheme.surface,
                                                            borderRadius: BorderRadius.circular(15.00),
                                                          ),
                                                          child: TextField(
                                                            scrollPadding: EdgeInsets.only(bottom:100),
                                                            textAlignVertical: TextAlignVertical.top,
                                                            style: Theme.of(context).textTheme.bodyText1,
                                                            keyboardType: TextInputType.text,
                                                            textCapitalization: TextCapitalization.words,
                                                            cursorColor: Theme.of(context).colorScheme.primary,
                                                            controller: fnameController,
                                                            focusNode: fNameFocusNode,
                                                            onChanged: (value){
                                                              print('You have entered Email $value');
                                                              if (Validators.validateName(value) == null) {
                                                                setState(() {
                                                                  isFNameValid = true;
                                                                  print('You have entered a VALID Email $value');
                                                                });
                                                              }else{
                                                                setState(() {
                                                                  isFNameValid = false;
                                                                });
                                                              }
                                                            },
                                                            onSubmitted: (value){
                                                              if (Validators.validateName(value) == null) {
                                                                isFNameValid = true;

                                                                if(fnameController.text != '' && isFNameValid){
                                                                  lNameFocusNode.requestFocus();
                                                                }

                                                              }else{
                                                                isFNameValid = false;
                                                              }
                                                            },
                                                            //initialValue: "address",
                                                            decoration: InputDecoration(
                                                              hintText: AppLocalizations.of(context)!.enterFirstName,
                                                              hintStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                              border: new OutlineInputBorder(
                                                                borderRadius:
                                                                new BorderRadius.circular(12.0),
                                                              ),
                                                              focusedBorder: InputBorder.none,
                                                              enabledBorder: InputBorder.none,
                                                              errorBorder: InputBorder.none,
                                                              disabledBorder: InputBorder.none,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(
                                              height: 20,
                                            ),

                                            //Entries Last Name
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(context)!.lastName,
                                                          style:
                                                          Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          child: (lnameController.text != '' && isLNameValid)
                                                              ?
                                                          SvgPicture.asset('assets/icons/tick-mark.svg', color: ThemeColor_green,)
                                                              :
                                                          (lnameController.text != '')  ? SvgPicture.asset('assets/icons/tick-cancel.svg', color: ThemeColor_red,) : Container()                                                      ),
                                                         ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 50,
                                                          padding: EdgeInsets.only(
                                                            left: 14,
                                                            right: 14,
                                                            bottom: 0,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).colorScheme.surface,
                                                            borderRadius: BorderRadius.circular(15.00),
                                                          ),
                                                          child: TextField(
                                                            scrollPadding: EdgeInsets.only(bottom:100),
                                                            textAlignVertical: TextAlignVertical.top,
                                                            style: Theme.of(context).textTheme.bodyText1,
                                                            keyboardType: TextInputType.text,
                                                            textCapitalization: TextCapitalization.words,
                                                            cursorColor: Theme.of(context).colorScheme.primary,
                                                            controller: lnameController,
                                                            focusNode: lNameFocusNode,
                                                            onChanged: (value){
                                                              print('You have entered LName $value');
                                                              if (Validators.validateName(value) == null) {
                                                                setState(() {
                                                                  isLNameValid = true;
                                                                  print('You have entered a VALID LName $value');
                                                                });
                                                              }else{
                                                                setState(() {
                                                                  isLNameValid = false;
                                                                });
                                                              }
                                                            },
                                                            onSubmitted: (value){
                                                              if (Validators.validateName(value) == null) {
                                                                isLNameValid = true;

                                                                if(lnameController.text != '' && isLNameValid){
                                                                  emailFocusNode.requestFocus();
                                                                }

                                                              }else{
                                                                isLNameValid = false;
                                                              }
                                                            },
                                                            decoration: InputDecoration(
                                                              hintText: AppLocalizations.of(context)!.enterLastName,
                                                              hintStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                              border: new OutlineInputBorder(
                                                                borderRadius:
                                                                new BorderRadius.circular(12.0),
                                                              ),
                                                              focusedBorder: InputBorder.none,
                                                              enabledBorder: InputBorder.none,
                                                              errorBorder: InputBorder.none,
                                                              disabledBorder: InputBorder.none,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(
                                              height: 20,
                                            ),

                                            //Entries Email
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(context)!.email,
                                                          style:
                                                          Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          child: (emailController.text != '' && isEmailValid)
                                                              ?
                                                          SvgPicture.asset('assets/icons/tick-mark.svg', color: ThemeColor_green,)
                                                              :
                                                          (emailController.text != '')  ? SvgPicture.asset('assets/icons/tick-cancel.svg', color: ThemeColor_red,) : Container()                                                      ),

                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 50,
                                                          padding: EdgeInsets.only(
                                                            left: 14,
                                                            right: 14,
                                                            bottom: 0,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).colorScheme.surface,

                                                            borderRadius: BorderRadius.circular(15.00),
                                                          ),
                                                          child: TextField(
                                                            scrollPadding: EdgeInsets.only(bottom:100),
                                                            textAlignVertical: TextAlignVertical.top,
                                                            style: Theme.of(context).textTheme.bodyText1,
                                                            keyboardType: TextInputType.text,
                                                            textCapitalization: TextCapitalization.none,
                                                            cursorColor: Theme.of(context).colorScheme.primary,
                                                            controller: emailController,
                                                            focusNode: emailFocusNode,
                                                            onChanged: (value){
                                                              print('You have entered Email $value');
                                                              if (Validators.validateEmail(value) == null) {
                                                                setState(() {
                                                                  isEmailValid = true;
                                                                  print('You have entered a VALID Email $value');
                                                                });
                                                              }else{
                                                                setState(() {
                                                                  isEmailValid = false;
                                                                });
                                                              }
                                                            },
                                                            onSubmitted: (value){
                                                              if (Validators.validateEmail(value) == null) {

                                                                setState(() {
                                                                  isEmailValid = true;
                                                                });

                                                                if(emailController.text != '' && isEmailValid){
                                                                  emailFocusNode.unfocus();
                                                                }

                                                              }else{
                                                                setState(() {
                                                                  isEmailValid = false;
                                                                });
                                                              }
                                                            },
                                                            decoration: InputDecoration(
                                                              hintText: AppLocalizations.of(context)!.enterEmail,
                                                              hintStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                              border: new OutlineInputBorder(
                                                                borderRadius:
                                                                new BorderRadius.circular(12.0),
                                                              ),
                                                              focusedBorder: InputBorder.none,
                                                              enabledBorder: InputBorder.none,
                                                              errorBorder: InputBorder.none,
                                                              disabledBorder: InputBorder.none,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),//username
                                          ],
                                        ),
                                      ),//Profile Info

                                    ],
                                  ),
                                ),
                              ],
                            ),


                            SizedBox(height: 50),

                            SafeArea(top: false,bottom: true, child: Container(height: 0,)),

                          ],
                        ),
                      ),


                      //Blur App Bar
                      Positioned(
                        top: 0,
                        child: Container(
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
                                        ),
                                        Container(
                                          child: Text(
                                            AppLocalizations.of(context)!.createYourProfile,
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
                        ),
                      ),//App Bar

                      //Button Add New
                      Positioned(
                        bottom: 0,
                        child: SafeArea(
                          top: false,
                          child: Container(
                            width: size.width,

                            height: 70,
                            color: Theme.of(context).colorScheme.background,
                            child: Center(
                              child: Container(
                                  width: size.width * 0.88,
                                  margin: EdgeInsets.only(
                                      left: size.width * 0.06,
                                      right: size.width * 0.06),
                                  child: (isEmailValid && isFNameValid && isFNameValid && !(fNameFocusNode.hasFocus || lNameFocusNode.hasFocus || emailFocusNode.hasFocus))
                                      ?
                                  Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.createProfile,
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                      ],
                                    ),
                                    size: 45,
                                    color: Theme.of(context).colorScheme.secondary,
                                    onPressed: () async{

                                      final fName = fnameController.text.trim();

                                      final lName = lnameController.text.trim();
                                      final email = emailController.text.trim();

                                      model.getProfileDetails(fName, lName, email);

                                      await model.createProfile(fName, lName, email, context);


                                    },
                                  )//CREATE ENABLED
                                      :
                                  (fNameFocusNode.hasFocus || lNameFocusNode.hasFocus || emailFocusNode.hasFocus) && ((fnameController.text != '' && isFNameValid) || (lnameController.text != '' && isLNameValid) || (emailController.text != '' && isEmailValid))
                                          ?
                                        Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.next,
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                      ],
                                    ),
                                    size: 45,
                                    color: Theme.of(context).colorScheme.primary,
                                    onPressed: (){

                                      if(fnameController.text != '' && isFNameValid){
                                        lNameFocusNode.requestFocus();
                                      }

                                      if(lnameController.text != '' && isLNameValid){
                                        emailFocusNode.requestFocus();
                                      }

                                      if(emailController.text != '' && isEmailValid){
                                        emailFocusNode.unfocus();
                                      }
                                    },
                                  )//NEXT ENABLED
                                          :
                                        Button(
                                            child:
                                            Row(
                                              mainAxisAlignment:  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.createProfile,
                                                  style: Theme.of(context).textTheme.button,
                                                ),
                                              ],
                                            ),
                                            size: 45,
                                            color: Theme.of(context).colorScheme.onSurface,
                                            onPressed: (){

                                            },
                                          )//DISABLED BUTTON
                              ),
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

