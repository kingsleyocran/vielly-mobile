
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:curve/app/app.router.dart';
import 'package:curve/data/models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:curve/presentation/widgets/custom_widgets/button_white.dart';
import 'package:curve/enums/enums.dart';
import 'package:curve/presentation/widgets/custom_widgets/ticket_preview_card.dart';
import 'package:curve/presentation/widgets/custom_widgets/onfailed_screen.dart';
import 'package:curve/app/app.locator.dart';
import 'bus_home_viewmodel.dart';
import 'package:curve/utilities/statusbar_util.dart';
import '../../../widgets/custom_widgets/busschedule_cards.dart';


class BusHomeView extends StatefulWidget {
  @override
  _BusHomeViewState createState() => _BusHomeViewState();
}

class _BusHomeViewState extends State<BusHomeView> {
  final ThemeService _themeService = locator<ThemeService>();

  //final _key = GlobalKey();
  //GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  GlobalKey<SliderMenuContainerState> _key = new GlobalKey<SliderMenuContainerState>();


  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {

    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());

    print("CURRENCY SYMBOL ${format.currencySymbol}"); // $
    print("CURRENCY NAME ${format.currencyName}"); // USD

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<BusHomeViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,

      //On Ready model once
      //fireOnModelReadyOnce: true,

      onModelReady: (model)async{await model.initialized(context);},

      viewModelBuilder: () => BusHomeViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
              Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: SliderMenuContainer(
                    //appBarColor: Colors.white,
                    appBarHeight: 0,
                    key: _key,
                    sliderMenuOpenSize: size.width*0.8,
                    sliderMenu: GestureDetector(
                          onTap: (){
                            _key.currentState!.toggle();
                          },
                          child: Scaffold(
                            backgroundColor: Theme.of(context).colorScheme.background,

                            body: SafeArea(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //ABOVE CONTENT
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //Settings
                                      Container(
                                        height: 45,
                                        width: size.width,
                                        margin: EdgeInsets.only(
                                          bottom: 5,
                                          top: 12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: size.width * 0.03,right: size.width * 0.03),
                                              height: 45,
                                              width: 45,

                                              child: RawMaterialButton(
                                                onPressed: () async{
                                                  await model.navigateToSettings();
                                                },
                                                shape: CircleBorder(),
                                                child: SvgPicture.asset(
                                                    'assets/icons/settings.svg', color: Theme.of(context).colorScheme.primary,),
                                                padding: EdgeInsets.all(2.0),
                                                //fillColor: XDColor_white,
                                                elevation: 0,
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(right: size.width*0.055),
                                              //height: 50,
                                              //width: 140,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(40),
                                                child: BackdropFilter(
                                                  filter:
                                                  ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                    alignment: Alignment.center,
                                                    color: Theme.of(context).colorScheme.onError.withOpacity(0.9),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 7),
                                                          child: SvgPicture.asset(
                                                              'assets/icons/wallet (3).svg'),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            (model.userProfile.wallet != null)
                                                                ?
                                                            (Localizations.localeOf(context).languageCode != "fr" ? 'GHC' : 'CFA') + (model.userProfile.wallet).toStringAsFixed(2)
                                                                :
                                                            "0.00",
                                                            style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.background),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20,),

                                      //Avatar
                                      Container(
                                        height: 120,
                                        width: 120,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(45.0)), //add border radius here
                                          child:
                                          Container(
                                              child: (model.profileFile == null)
                                                  ?
                                              Container(
                                                  child: (model.userProfile.originalImage == null)
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
                                                    imageUrl: '${model.userProfile.originalImage}',
                                                    fit: BoxFit.fill,
                                                    fadeInCurve: Curves.easeIn,
                                                    fadeInDuration: Duration(milliseconds: 1000),
                                                    cacheManager: model.cacheManager,
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                  )

                                                       */




                                              )
                                                  :
                                              Image.file(model.profileFile)
                                          ),

                                        ),
                                      ),
                                      SizedBox(height: 15,),

                                      //NAME
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
                                      SizedBox(height: 15,),

                                      //Update Button
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
                                                  AppLocalizations.of(context)!.updateProfile,
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
                                      ),
                                      SizedBox(height: 15,),

                                      //LIST LINKS
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.width,
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15.0),
                                                color: Theme.of(context).colorScheme.surface,
                                              ),

                                              child: Column(
                                                children: [

                                                  //Your Trips
                                                  RawMaterialButton(
                                                    onPressed: (){
                                                      //model.navigateToRideHistory();
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                      height: 55,
                                                      width: size.width * 0.88,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              AppLocalizations.of(context)!.yourTrips,
                                                              style: Theme.of(context).textTheme.bodyText1,
                                                            ),
                                                          ),
                                                          SvgPicture.asset('assets/icons/arrowforward.svg'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  //Refer friends
                                                  RawMaterialButton(
                                                    onPressed: (){},
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                      height: 55,
                                                      width: size.width * 0.88,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              AppLocalizations.of(context)!.referFriends,
                                                              style: Theme.of(context).textTheme.bodyText1,
                                                            ),
                                                          ),
                                                          SvgPicture.asset('assets/icons/arrowforward.svg'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  //Payment Methods
                                                  RawMaterialButton(
                                                    onPressed: (){
                                                      model.navigateToPaymentOpt();
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                      height: 55,
                                                      width: size.width * 0.88,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              AppLocalizations.of(context)!.paymentMethods,
                                                              style: Theme.of(context).textTheme.bodyText1,
                                                            ),
                                                          ),
                                                          SvgPicture.asset('assets/icons/arrowforward.svg'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),

                                  //BECOME A DRIVER
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.width,
                                              padding: EdgeInsets.symmetric(vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15.0),
                                                color: Theme.of(context).colorScheme.secondary,
                                              ),

                                              child: Column(
                                                children: [
                                                  //Become a driver
                                                  RawMaterialButton(
                                                    onPressed: (){},
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                      height: 55,
                                                      width: size.width * 0.88,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              AppLocalizations.of(context)!.becomeADriver,
                                                              style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.background),
                                                            ),
                                                          ),
                                                          SvgPicture.asset('assets/icons/arrowforward.svg', color: Theme.of(context).colorScheme.background,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 15,)
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ),
                        ),

                    sliderMain:
                        //PAGE WIDGET
                        Scaffold(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          body: SafeArea(
                            bottom: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //MENU AND GREETING
                                Container(
                                  width: size.width,
                                  margin: EdgeInsets.only(
                                    left: size.width * 0.06,
                                    right: size.width * 0.06,
                                    bottom: 5,
                                    top: 15,
                                  ),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      //MENU BUTTON
                                      InkWell(
                                        onTap: (){
                                          _key.currentState!.toggle();
                                        },
                                        child: Container(
                                          height: 40.00,
                                          width: 40.00,
                                          margin: EdgeInsets.only(
                                              right: 10
                                          ),
                                          padding: EdgeInsets.all(11),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.surface,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: SvgPicture.asset('assets/icons/menu_icon.svg', color: Theme.of(context).colorScheme.onBackground,),
                                        ),
                                      ),

                                      const SizedBox(height: 20,),

                                      //GREETING
                                      Container(
                                          child:
                                          Text((model.userProfile == null)? '${AppLocalizations.of(context)!.helloThere}!':
                                          "${AppLocalizations.of(context)!.helloThere}, ${((model.userProfile.name).split(' '))[0]}!",
                                            style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onBackground),
                                          )
                                      ),

                                    ],
                                  ),
                                ),

                                //WHERE TO?
                                Container(
                                  width: size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                            left: size.width * 0.06,
                                            right: size.width * 0.06,
                                            top: 10,
                                            bottom: 5,
                                          ),
                                          child:
                                          InkWell(
                                            onTap: () async{

                                              model.navigateToSearch();

                                            },
                                            child: Container(
                                              height: 45.00,
                                              width: size.width*0.88,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.surface,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              padding: EdgeInsets.only(left: 15,right: 5, top: 5, bottom: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Container(
                                                    child: Text(
                                                      "${AppLocalizations.of(context)!.whereTo}",
                                                      style:
                                                      Theme.of(context).textTheme.bodyText1,
                                                    ),
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                                    height: 45.00,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () async {

                                                        //model.getNavigator.navigateTo(Routes.onDemandRideView);

                                                        await model.openBusScheduleBottomSheet();

                                                      },
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                "${AppLocalizations.of(context)!.now}",
                                                                style:
                                                                Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).colorScheme.onBackground),
                                                              ),
                                                            ),

                                                            const SizedBox(width: 12,),

                                                            Container(
                                                              child: Transform.rotate(
                                                                angle: 90 * pi/180,
                                                                child: SvgPicture.asset(
                                                                    'assets/icons/arrowforward.svg',
                                                                  color: Theme.of(context).colorScheme.onBackground,
                                                                  width: 8,
                                                                ),
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
                                          )
                                      ),
                                    ],
                                  ),
                                ),

                                //Ticket Preview or Locations
                                Container(
                                  child: (model.ticketDetailsList == null)
                                      ?
                                  //SAVED LOCATIONS
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
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
                                              InkWell(
                                                onTap: () async{
                                                  AddressDetails data = AddressDetails();
                                                  data.placeName = model.isHomeLocation.name;
                                                  data.latitude = model.isHomeLocation.location.latitude;
                                                  data.longitude = model.isHomeLocation.location.longitude;

                                                  model.getSharedPrefManager.setPrefDropOffAddress(data);

                                                  ///await model.triggerSearchTrip(context);
                                                },
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icons/homeicon.svg', color: Theme.of(context).colorScheme.primary,),
                                                      SizedBox(width: 15),
                                                      Container(
                                                        child: Text(
                                                          'Go Home',
                                                          style: Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onError),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ) //GO HOME
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () async{
                                                  AddressDetails data = AddressDetails();
                                                  data.placeName = model.isWorkLocation.name;
                                                  data.latitude = model.isWorkLocation.location.latitude;
                                                  data.longitude = model.isWorkLocation.location.longitude;

                                                  model.getSharedPrefManager.setPrefDropOffAddress(data);

                                                  ///await model.triggerSearchTrip(context);
                                                },
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icons/workicon.svg', color: Theme.of(context).colorScheme.primary,),
                                                      SizedBox(width: 15),
                                                      Container(
                                                        child: Text(
                                                          'Go to Work',
                                                          style: Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onError),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ) //GO WORK
                                            : //Location row
                                        Container(
                                          height: 45,
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
                                        SizedBox(height: 10,),
                                      ],
                                    ),
                                  )
                                      :
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                            top: 10,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!.recentOrder,
                                            style:
                                            Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                          ),
                                        ),

                                        SizedBox(height: 8,),

                                        TicketPreviewCard(
                                          ticketDetails: model.ticketDetailsList[0],//[model.ticketDetailsList.length - 1],
                                          function: (){
                                            model.navigateToTicket(model.ticketDetailsList[0]);
                                          },
                                        ),



                                        //ALL TICKET BUTTON
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06),
                                          width: size.width,

                                          child: TextButton(
                                            style: ButtonStyle(
                                              overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.1)),

                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
                                            onPressed: (){

                                              model.navigateToAllTickets();

                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!.seeAllTickets,
                                              style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 10,),
                                      ],
                                    ),
                                  ),
                                ),

                                //BUS SCHEDULE AREA
                                Expanded(
                                  child: Container(
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      color:
                                      (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onSurface ,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                    ),

                                    child:
                                    (model.loadingState == LoadingState.onFailed)
                                        ?
                                    OnFailedScreen(
                                      onRetryFunction: ()async{
                                        model.getBusSchedules();
                                      },
                                    )
                                        :
                                    SmartRefresher(
                                      physics: BouncingScrollPhysics(),
                                      enablePullDown: true,
                                      enablePullUp: false,
                                      header: 	WaterDropHeader(
                                        waterDropColor: Theme.of(context).colorScheme.primary,
                                      ),
                                      /*
                                  footer: CustomFooter(
                                  builder: (BuildContext context,LoadStatus mode){
                                    Widget body ;
                                    if(mode==LoadStatus.idle){
                                      body =  Text("pull up load");
                                    }
                                    else if(mode==LoadStatus.loading){
                                      body =  CupertinoActivityIndicator();
                                    }
                                    else if(mode == LoadStatus.failed){
                                      body = Text("Load Failed!Click retry!");
                                    }
                                    else if(mode == LoadStatus.canLoading){
                                      body = Text("release to load more");
                                    }
                                    else{
                                      body = Text("No more Data");
                                    }
                                    return Container(
                                      height: 55.0,
                                      child: Center(child:body),
                                    );
                                  },
                                ),
                                                             */
                                      controller: model.refreshController,
                                      onRefresh: model.onRefresh,
                                      onLoading: model.onLoading,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              ListView.separated(
                                                key: PageStorageKey('storage-key'),
                                                //physics: ClampingScrollPhysics(),
                                                physics: NeverScrollableScrollPhysics(),
                                                separatorBuilder: (BuildContext context, int index) =>
                                                    Container(

                                                    ),
                                                itemCount: (model.loadingState == LoadingState.loading) ? 2 : model.busScheduleList.length,
                                                shrinkWrap: true,

                                                itemBuilder: (context, index) {
                                                  return
                                                    (model.loadingState == LoadingState.loading)
                                                        ?
                                                    BusScheduleEmptyCard()
                                                        :
                                                    BusScheduleCard(
                                                        busSchedule: model.busScheduleList[index],

                                                        function: () {
                                                          model.navigateToBusDetailsBusSelect(busSchedule: model.busScheduleList[index]);
                                                        }
                                                    );

                                                },

                                              ),
                                              SizedBox(height: 20,),
                                            ],
                                          ),
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
          ),
    );
  }
}


