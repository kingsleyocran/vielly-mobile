import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:curve/presentation/configurations/colors.dart';
import 'package:curve/utilities/formvalidators_util.dart';
import 'package:curve/utilities/statusbar_util.dart';
import 'editprofile_viewmodel.dart';

class EditProfileView extends StatefulWidget {

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //bool _visible;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(),
      onModelReady: (model) => model.initialise(),
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
                                                          (model.userProfile.originalImage == null)
                                                              ?
                                                          Image(image: AssetImage('assets/images/emptyprofile.png'), fit: BoxFit.fill)
                                                              :
                                                          Image(
                                                            image: CachedNetworkImageProvider(
                                                                model.userProfile.originalImage,
                                                                cacheManager: model.cacheManager
                                                            ),
                                                          )
                                                          /*
                                                          CachedNetworkImage(
                                                            placeholder: (context, url) => SpinKitRing(lineWidth: 3,
                                                              color: Theme.of(context).colorScheme.primary,),
                                                            imageUrl:
                                                            '${model.userProfile.originalImage}',
                                                            cacheManager: model.cacheManager,
                                                            fit: BoxFit.fill,
                                                            fadeInCurve: Curves.easeIn,
                                                            fadeInDuration: Duration(milliseconds: 1000),
                                                          ),

                                                           */
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

                                      //Profile Info
                                      Container(
                                        width: size.width,
                                        margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                                        child: Column(
                                          children: [
                                            //Entries Name
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
                                                          '${AppLocalizations.of(context)!.name}',
                                                          style:
                                                          Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          child:

                                                              (model.isNameValid == 'true')
                                                                  ?
                                                              SvgPicture.asset('assets/icons/tick-mark.svg', color: ThemeColor_green,)
                                                                  :
                                                              (model.isNameValid == 'null')
                                                                  ? Container()
                                                                  : SvgPicture.asset('assets/icons/tick-cancel.svg', color: ThemeColor_red,)
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(height: 10,),

                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 45,
                                                          padding: EdgeInsets.only(
                                                            left: 14,
                                                            right: 14,
                                                            bottom:2,
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
                                                            controller: model.nameController,
                                                            focusNode: model.nameFocusNode,
                                                            onChanged: (value){
                                                              print('You have entered Name $value');
                                                              if (Validators.validateName(value) == null) {
                                                                model.setIsNameValid(true);

                                                              }else{
                                                                model.setIsNameValid(false);
                                                              }
                                                            },
                                                            onSubmitted: (value){
                                                              if (Validators.validateName(value) == null) {
                                                                model.setIsNameValid(true);

                                                                FocusScope.of(context).requestFocus(FocusNode());

                                                              }else{
                                                                model.setIsNameValid(false);
                                                              }
                                                            },
                                                            //initialValue: "address",
                                                            decoration: InputDecoration(
                                                              hintText: "${AppLocalizations.of(context)!.enterName}",
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
                                                          '${AppLocalizations.of(context)!.email}',
                                                          style:
                                                          Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                        ),
                                                        Container(
                                                            height: 20,
                                                            width: 20,
                                                            child:

                                                            (model.isEmailValid == 'true' )
                                                                            ?
                                                                SvgPicture.asset('assets/icons/tick-mark.svg', color: ThemeColor_green,)
                                                                            :
                                                            (model.isEmailValid == 'null')
                                                            ? Container()
                                                            : SvgPicture.asset('assets/icons/tick-cancel.svg', color: ThemeColor_red,))
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 45,
                                                          padding: EdgeInsets.only(
                                                            left: 14,
                                                            right: 14,
                                                            bottom:2,
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
                                                            controller: model.emailController,
                                                            focusNode: model.emailFocusNode,
                                                            onChanged: (value){
                                                              print('You have entered Email $value');
                                                              if (Validators.validateEmail(value) == null) {
                                                                model.setIsEmailValid(true);


                                                              }else{
                                                                model.setIsEmailValid(false);
                                                              }
                                                            },
                                                            onSubmitted: (value){
                                                              if (Validators.validateEmail(value) == null) {
                                                                model.setIsEmailValid(true);

                                                                FocusScope.of(context).requestFocus(FocusNode());

                                                              }else{
                                                                model.setIsEmailValid(false);
                                                              }
                                                            },
                                                            decoration: InputDecoration(
                                                              hintText: "${AppLocalizations.of(context)!.enterEmail}",
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

                                            SizedBox(
                                              height: 20,
                                            ),

                                            //Phone Number
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      '${AppLocalizations.of(context)!.phone}',
                                                      style:
                                                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                    ),
                                                  ),

                                                  SizedBox(height: 10,),

                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: RawMaterialButton(
                                                          onPressed: (){

                                                          },
                                                          child: Container(
                                                            height: 45,
                                                            padding: EdgeInsets.only(
                                                              left: 14,
                                                              right: 14,
                                                              bottom: 0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context).colorScheme.surface,

                                                              borderRadius: BorderRadius.circular(15.00),
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text((
                                                                    (model.userProfile.phone != null)
                                                                        ?
                                                                    model.userProfile.phone
                                                                        :
                                                                    ''),
                                                                  style: Theme.of(context).textTheme.bodyText1,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),//Profile Info

                                      SizedBox(height: 10,),

                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                                        //width: 53,
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            //Navigator.pop(context);
                                          },

                                          child: Text(
                                            '${AppLocalizations.of(context)!.changePhoneNumber}',
                                            style:
                                            Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                      ),

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
                                          child: RawMaterialButton(
                                            onPressed: () {
                                              model.navigateBackLogic();
                                            },
                                            shape: CircleBorder(),
                                            child: SvgPicture.asset(
                                                'assets/icons/icon-arrow-back-black.svg',
                                              color: Theme.of(context).colorScheme.onSurface,),
                                            padding: EdgeInsets.all(2.0),
                                            elevation: 0,
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            '${AppLocalizations.of(context)!.editProfile}',
                                            style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onSurface),
                                          ),
                                        ),//Page Header text
                                        Container(
                                          margin: EdgeInsets.only(right: size.width * 0.05),

                                          width: 53,
                                          child: RawMaterialButton(
                                            onPressed: () {

                                              if(((model.isEmailValid != 'false') && (model.isNameValid != 'false'))){
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                model.editProfile();
                                              }else if(model.isEmailValid == 'false'){
                                                model.showSnackBarRedAlert('Make sure you have entered a valid name');
                                              }else if(model.isNameValid == 'false'){
                                                model.showSnackBarRedAlert('Make sure you have entered a valid email');
                                              }

                                            },

                                            child: Text(
                                              'SAVE',
                                              style:
                                              Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.primary),
                                            ),
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
                      ),//App Bar
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}