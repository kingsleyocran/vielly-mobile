
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:curve/app/app.router.dart';
import 'package:curve/data/models/address.dart';
import '../../../../app/app.locator.dart';
import '../../../../presentation/widgets/custom_widgets/button.dart';
import 'on_demand_ride_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';



class OnDemandRideView extends StatefulWidget {
  @override
  _OnDemandRideViewState createState() => _OnDemandRideViewState();
}

class _OnDemandRideViewState extends State<OnDemandRideView> with TickerProviderStateMixin{

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String? mapStyleLight;
  String? mapStyleDark;
  bool isMapCreated = false;
  GoogleMapController? setMapController;


  @override
  void initState() {

     rootBundle.loadString('assets/map_styles/map_style_light.txt').then((string) {
      mapStyleLight = string;

    });

    rootBundle.loadString('assets/map_styles/map_style_dark.txt').then((string) {
      mapStyleDark = string;

    });
    // TODO: implement initState
    super.initState();
  }

  void changeMapTheme(controller){
    controller.setMapStyle(
        (Theme.of(context).colorScheme.brightness == Brightness.dark)
            ?
        mapStyleDark
            :
        mapStyleLight
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isMapCreated){
      changeMapTheme(setMapController);
    }

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<OnDemandRideViewModel>.reactive(

      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      fireOnModelReadyOnce: true,

      onModelReady: (model) => model.initialiseOnModelReady(context),


      viewModelBuilder: () => OnDemandRideViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              body: Stack(
                children: [

                  //Google Map
                  GoogleMap(
                    padding: EdgeInsets.only(bottom: model.mapPadding, top: 120),
                    initialCameraPosition: model.kInitialPosition,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    //onCameraMove: _updateCameraPosition,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    polylines: model.polyLines,
                    markers: model.markers,
                    circles: model.circles,
                    zoomGesturesEnabled: true,
                    onMapCreated: (GoogleMapController controller){
                      //Initialize map style here
                      model.onMapCreated(controller);

                      setMapController = controller;

                      isMapCreated = true;
                      changeMapTheme(controller);
                      setState(() {});
                    },
                  ),

                  SafeArea(
                    child: Stack(
                      children: [

                        //Set Location button
                        Positioned(
                          bottom: 270,
                          right: 0,
                          child:
                          AnimatedOpacity(
                            opacity: model.setLocationOpacity,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: GestureDetector(
                              onTap: () {
                                if(model.setLocationOpacity == 1){
                                  model.setPositionLocator();

                                  //model.showTripOngoingSheet();

                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: size.width * 0.06,
                                ),
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: BackdropFilter(
                                    filter:
                                    ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Theme.of(context).colorScheme.onError.withOpacity(0.8),
                                      child: SvgPicture.asset(
                                          'assets/icons/locationicon.svg', color: Theme.of(context).colorScheme.background),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ),

                        //User Position
                        Positioned(
                          bottom: 330,
                          right: 0,
                          child:
                          AnimatedOpacity(
                            opacity: model.userFocusOpacity,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: GestureDetector(
                              onTap: () {
                                if(model.tripDetails != null)
                                  {model.userWalkingFocus();}
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: size.width * 0.06,
                                ),
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: BackdropFilter(
                                    filter:
                                    ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Theme.of(context).colorScheme.onError.withOpacity(0.8),
                                      child: SvgPicture.asset(
                                          'assets/icons/userwalking.svg', color: Theme.of(context).colorScheme.background),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ),

                        //Driver Position Button
                        Positioned(
                          bottom: 390,
                          right: 0,
                          child:
                          AnimatedOpacity(
                            opacity: model.driverFocusOpacity,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: GestureDetector(
                              onTap: () {
                                if(model.tripDetails != null){
                                  model.driverUserOnMapFocus();
                                }

                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: size.width * 0.06,
                                ),
                                height: 50,
                                width: 50,

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),

                                  child: BackdropFilter(
                                    filter:
                                    ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      padding: EdgeInsets.all(7),
                                      alignment: Alignment.center,
                                      color: Theme.of(context).colorScheme.onError.withOpacity(0.8),
                                      child: SvgPicture.asset(
                                          'assets/icons/drivercar.svg', color: Theme.of(context).colorScheme.background),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ),

                        //Wallet home Main
                        /*
                        Positioned(
                          top: 20,
                          child: AnimatedOpacity(
                            opacity: model.walletOpacity,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Container(


                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: size.width * 0.06,
                                    ),
                                    //height: 50,
                                    //width: 140,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: BackdropFilter(
                                        filter:
                                        ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          alignment: Alignment.center,
                                          color: Theme.of(context).colorScheme.onError.withOpacity(0.8),
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
                                                  (model.userProfile != null)
                                                      ?
                                                  'GHS ' + (model.userProfile.wallet).toStringAsFixed(2)
                                                      :
                                                  "GHS 0.00",
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
                          ),
                        ),
                       */

                        //Top Location Confirm
                        Positioned(
                          top: 20,
                          left: 60,
                          child: AnimatedOpacity(
                            opacity: model.topLocationOpacity,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                              height: 56,
                              width: size.width - 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Expanded(
                                    child: Container(
                                      height: 54.00,
                                      //width: size.width * 0.7,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Theme.of(context).colorScheme.onError.withOpacity(0.8),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 15),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          child: SvgPicture.asset(
                                                              'assets/icons/seticon1.svg'  , color: Theme.of(context).colorScheme.primary),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        Expanded(
                                                          child: Container(
                                                            child: Text(

                                                              '${(model.pickUpAddress != null)
                                                                  ?model.pickUpAddress.placeName
                                                                  : 'No Location'}',
                                                              style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.background),
                                                              textAlign: TextAlign.left,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          child: SvgPicture.asset(
                                                              'assets/icons/seticon2.svg'  , color: Theme.of(context).colorScheme.secondary),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        Expanded(
                                                          child: Container(
                                                            child: Text(
                                                              '${(model.dropOffAddress != null)
                                                                  ?model.dropOffAddress.placeName
                                                                  : 'No Location'}',
                                                              style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.background),
                                                              textAlign: TextAlign.left,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  /*
                            Container(
                              height: 47,
                              width: 47,

                            ),

                             */
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Meet at pickup point
                        Positioned(
                          top: 20,
                          left: 60,
                          child: AnimatedOpacity(
                            opacity: model.meetAtPickupOpacity,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                              height: 56,
                              width: size.width - 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //BackButton
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: Container(
                                      height: 54.00,
                                      //width: size.width * 0.7,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Theme.of(context).colorScheme.onError.withOpacity(0.8),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 15),
                                              child: Container(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        width: 20,
                                                        child: SvgPicture.asset(
                                                            'assets/icons/seticon2.svg' , color: Theme.of(context).colorScheme.secondary,),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                      child: Flexible(
                                                        child: Text('Meet your driver at ${(model.tripDetails != null) ? model.tripDetails.pickupLocation :' '}',
                                                          style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.background),
                                                          textAlign: TextAlign.left,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  /*
                            Container(
                              height: 47,
                              width: 47,

                            ),

                             */
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Trip Status Top
                        Positioned(
                          top: 20,
                          child: AnimatedOpacity(
                            opacity: model.tripTopStatusOpacity,//tripStatusOpacity,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                              height: 56,
                              width: size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //BackButton
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: Container(
                                      height: 54.00,
                                      //width: size.width * 0.7,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: Theme.of(context).colorScheme.onError.withOpacity(0.8),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 6,horizontal: 15),
                                              child: Container(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        width: 20,
                                                        child: SvgPicture.asset(
                                                            'assets/icons/caricon_ongoing.svg' , color: Theme.of(context).colorScheme.primary,),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                      child: Flexible(
                                                        child: Text('Heading to a dropoff spot near you',
                                                          style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.background),
                                                          textAlign: TextAlign.left,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Top Cancel
                        Positioned(
                          top: 20,
                          left: 0,
                          child:
                          AnimatedOpacity(
                            opacity: (model.topLocationOpacity == 1 || model.meetAtPickupOpacity == 1) ? 1 : 0,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: GestureDetector(
                              onTap: () {
                                if(model.topLocationOpacity == 1 || model.meetAtPickupOpacity == 1)
                                {
                                  if (model.rideTypeSelector){
                                    if(model.tripDetails != null){
                                      model.navigateToCancel();
                                    }else{
                                      //model.triggerResetRide();
                                      model.getNavigator.back();
                                      print('Reset UI');
                                    }
                                  }else{
                                    model.getNavigator.back();
                                  }

                                }


                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: size.width * 0.06,
                                ),
                                height: 54,
                                width: 54,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: BackdropFilter(
                                    filter:
                                    ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Theme.of(context).colorScheme.onError.withOpacity(0.8),
                                      child: SvgPicture.asset(
                                          'assets/icons/icon-close-back-black.svg' ,color: Theme.of(context).colorScheme.background),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ),





                        //PANELS
                        //Select Ride Panel
                        Positioned(
                            bottom: 0,
                            child: AnimatedSize(
                              //vsync: this,
                              duration: new Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuart,
                              child: Container(
                                height: model.homeSheetHeight,
                                width: size.width,
                                //padding: EdgeInsets.only(bottom: 10),

                                child: Stack(
                                  children: [
                                    SlidingUpPanel(
                                      minHeight: model.homeSheetHeight,
                                      maxHeight: model.homeSheetHeight,
                                      renderPanelSheet: false,
                                      panel: Container(
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.background,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            topLeft: Radius.circular(30),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.onBackground.withOpacity(0.2) : Theme.of(context).colorScheme.onBackground.withOpacity(0.0),                                            spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.chooseARide,
                                              style:
                                              Theme.of(context).textTheme.bodyText1,
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(
                                                left: size.width * 0.06,
                                                right: size.width * 0.06,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              height: 260,
                                              child: Row(
                                                  children: [
                                                    //Car select
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          model.switchRideSelector();
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(12),
                                                          decoration: BoxDecoration(
                                                            color: (model.rideTypeSelector) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                            child: Column(
                                                                children: [
                                                                  Text(
                                                                    "Curver",
                                                                    style:
                                                                    Theme.of(context).textTheme.bodyText1!.copyWith(color: (model.rideTypeSelector) ? Colors.white :Theme.of(context).colorScheme.primary),
                                                                  ),
                                                                  const SizedBox(height: 2,),
                                                                  Text(
                                                                    "Fast rides",
                                                                    style:
                                                                    Theme.of(context).textTheme.caption!.copyWith(color: (model.rideTypeSelector) ? Theme.of(context).colorScheme.primaryVariant : Theme.of(context).colorScheme.onBackground),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                  const SizedBox(height: 5,),

                                                                  Container(
                                                                    height: 70,
                                                                    width: 75,
                                                                      child: Image.asset("assets/images/curve_curver.png"),
                                                                  ),
                                                                  const SizedBox(height: 5,),

                                                                  Text(
                                                                    (model.searchTripDetails == null) ? "GHC -" : "GHC ${model.charge}" ,
                                                                    style:
                                                                    Theme.of(context).textTheme.headline5!.copyWith(color: (model.rideTypeSelector) ? Colors.white : Theme.of(context).colorScheme.primary),
                                                                  ),
                                                                  const SizedBox(height: 5,),


                                                                  //Terminals
                                                                  Container(
                                                                    width: size.width,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          AppLocalizations.of(context)!.pickUp,
                                                                          style:
                                                                          Theme.of(context).textTheme.caption!.copyWith(color: (model.rideTypeSelector) ? Theme.of(context).colorScheme.primaryVariant : Theme.of(context).colorScheme.onSurface),
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),

                                                                        Text(
                                                                            (model.searchTripDetails == null) ? "Loading..." : "${model.pickUpAddress.placeName}",
                                                                          style:
                                                                          Theme.of(context).textTheme.bodyText2!.copyWith(color: (model.rideTypeSelector) ? Colors.white : Theme.of(context).colorScheme.onBackground),
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),

                                                                        const SizedBox(height: 10,),

                                                                        Text(
                                                                          AppLocalizations.of(context)!.dropOff,
                                                                          style:
                                                                          Theme.of(context).textTheme.caption!.copyWith(color: (model.rideTypeSelector) ? Theme.of(context).colorScheme.primaryVariant : Theme.of(context).colorScheme.onSurface),
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),

                                                                        Text(
                                                                          (model.searchTripDetails == null) ? "Loading..." : "${model.dropOffAddress.placeName}",
                                                                          style:
                                                                          Theme.of(context).textTheme.bodyText2!.copyWith(color: (model.rideTypeSelector) ? Colors.white : Theme.of(context).colorScheme.onBackground),
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),


                                                                ],
                                                            ),
                                                        ),
                                                      ),

                                                    ),

                                                    const SizedBox(width: 15,),

                                                    //Bus Select
                                                    Expanded(
                                                      child: GestureDetector(
                                                          onTap: (){
                                                            model.switchRideSelector();
                                                          },
                                                        child: Container(
                                                          padding: EdgeInsets.all(12),
                                                          decoration: BoxDecoration(
                                                            color: !(model.rideTypeSelector) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Shuttle Share",
                                                                style:
                                                                Theme.of(context).textTheme.bodyText1!.copyWith(color: !(model.rideTypeSelector) ? Colors.white : Theme.of(context).colorScheme.primary),
                                                              ),
                                                              const SizedBox(height: 2,),
                                                              Text(
                                                                "Affordable Bus rides",
                                                                style:
                                                                Theme.of(context).textTheme.caption!.copyWith(color:  !(model.rideTypeSelector) ? Theme.of(context).colorScheme.primaryVariant : Theme.of(context).colorScheme.onBackground),
                                                              ),
                                                              const SizedBox(height: 5,),

                                                              Container(
                                                                height: 70,
                                                                width: 75,
                                                                child: Image.asset("assets/images/curve_shutler.png"),
                                                              ),
                                                              const SizedBox(height: 5,),

                                                              Text(
                                                                (model.searchTripBusDetails == null) ? "GHC -" : "GHC ${model.chargeBus}" ,
                                                                style:
                                                                Theme.of(context).textTheme.headline5!.copyWith(color: !(model.rideTypeSelector) ? Colors.white : Theme.of(context).colorScheme.primary),
                                                              ),
                                                              const SizedBox(height: 5,),


                                                              //Terminals
                                                              Container(
                                                                width: size.width,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      AppLocalizations.of(context)!.pickupTerminal,
                                                                      style:
                                                                      Theme.of(context).textTheme.caption!.copyWith(color: !(model.rideTypeSelector) ? Theme.of(context).colorScheme.primaryVariant : Theme.of(context).colorScheme.onSurface),
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),

                                                                    Text(
                                                                      (model.searchTripBusDetails == null) ? "Loading..." : "${model.searchTripBusDetails.pickupName}" ,
                                                                      style:
                                                                      Theme.of(context).textTheme.bodyText2!.copyWith(color: !(model.rideTypeSelector) ? Colors.white : Theme.of(context).colorScheme.onBackground),
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),

                                                                    const SizedBox(height: 10,),

                                                                    Text(
                                                                      AppLocalizations.of(context)!.dropOffTerminal,
                                                                      style:
                                                                      Theme.of(context).textTheme.caption!.copyWith(color: !(model.rideTypeSelector) ? Theme.of(context).colorScheme.primaryVariant : Theme.of(context).colorScheme.onSurface),
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),

                                                                    Text(
                                                                      (model.searchTripBusDetails == null) ? "Loading..." : "${model.searchTripBusDetails.dropoffName}",
                                                                      style:
                                                                      Theme.of(context).textTheme.bodyText2!.copyWith(color: !(model.rideTypeSelector) ? Colors.white : Theme.of(context).colorScheme.onBackground),
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ],
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


                                            ///PAy with Cash
                                            /*
                                            Container(
                                              color:  Theme.of(context).colorScheme.background,
                                              height: 30,
                                              margin: EdgeInsets.only(
                                                  left: size.width * 0.06,
                                                  right: size.width * 0.06),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 28,
                                                    child: RawMaterialButton(
                                                      onPressed: () async{

                                                        await model.navigateToPaymentOpt();

                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/icons/addpaymentflat.svg', color: Theme.of(context).colorScheme.primary,),
                                                          SizedBox(
                                                            width: 5,),
                                                          Container(
                                                            margin: EdgeInsets.only(left: 5),
                                                            child: Text(
                                                              'Pay with ${model.selectedProvider}',
                                                              style:  Theme.of(context).textTheme.subtitle1!.apply(color:  Theme.of(context).colorScheme.primary),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                             //TextRow
                                             */
                                            Container(
                                              color:  Theme.of(context).colorScheme.background,
                                              height: 75,
                                            ), //Space to cover stack
                                          ],
                                        ),
                                      ),
                                    ),

                                    //Button
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                          width: size.width,
                                          height: 75,
                                          color:  Theme.of(context).colorScheme.background,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: size.width,
                                                child: Container(
                                                    width: size.width * 0.88,
                                                    margin: EdgeInsets.only(
                                                        left: size.width * 0.06,
                                                        right: size.width * 0.06),
                                                    child:
                                                    (model.charge != null )
                                                        ?
                                                    Button(
                                                      child:
                                                      Row(
                                                        mainAxisAlignment:  MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "CONFIRM",
                                                            style:  Theme.of(context).textTheme.button,
                                                          ),
                                                        ],
                                                      ),
                                                      size: 45,
                                                      color:  Theme.of(context).colorScheme.secondary,
                                                      onPressed: () async{

                                                        await model.triggerSelectRideType(context);


                                                      },
                                                    )
                                                        :
                                                    Button(
                                                      child:
                                                      Row(
                                                        mainAxisAlignment:  MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "CONFIRM",
                                                            style:  Theme.of(context).textTheme.button,
                                                          ),
                                                        ],
                                                      ),
                                                      size: 45,
                                                      color:  Theme.of(context).colorScheme.onSurface,
                                                    )

                                                ),
                                              ),
                                            ],
                                          )),
                                    ),//Button Side
                                  ],
                                ),
                              ),
                            )
                        ),

                        //Confirm Seats & Price
                        Positioned(
                          bottom:0,
                          right:0,
                          child: AnimatedSize(
                            //vsync: this,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOutQuart,
                            child: Container(
                              height: model.rideDetailsHeight,
                              margin: EdgeInsets.only(top: 10),
                              width: size.width,
                              child: Stack(
                                children: [
                                  SlidingUpPanel(
                                    minHeight: 240,
                                    maxHeight: 240,
                                    renderPanelSheet: false,
                                    panel: Container(
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.background,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.onBackground.withOpacity(0.2) : Theme.of(context).colorScheme.onBackground.withOpacity(0.0),                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          //Money Row
                                          Container(
                                            padding: EdgeInsets.only(left: size.width*0.06,right: size.width*0.06),
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color:  Theme.of(context).colorScheme.secondaryVariant,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                topLeft: Radius.circular(30),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  //width: 100,
                                                  //color: Colors.grey,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 35,top: 15),
                                                        width: 120.0,
                                                        height: 30.0,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          color:  Theme.of(context).colorScheme.background,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              height: 22,
                                                              width: 22,
                                                              //color: Colors.black,
                                                              child: Image.asset(
                                                                'assets/images/Gamification project avatar.png',
                                                                fit: BoxFit.contain,
                                                                alignment: Alignment.center,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            Text(
                                                              model.rideTypeSelector ? '3' : "${model.availableSeats}",
                                                              style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface ),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            SizedBox(width: 10,),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 67,
                                                        width: 100,
                                                        //color: Colors.black,
                                                        child: Image.asset(
                                                          model.rideTypeSelector ? 'assets/images/Gamification project car.png' : 'assets/images/Gamification project bus.png',
                                                          fit: BoxFit.contain,
                                                          alignment: Alignment.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),//Illustration

                                                Container(
                                                  child: (model.searchTripDetails == null)
                                                      ?
                                                  Text('Loading...',
                                                    style:  Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                    textAlign: TextAlign.left,
                                                  )
                                                      :
                                                  Text('GHC ${(model.rideTypeSelector ? model.charge : model.chargeBus).toStringAsFixed(2)}',
                                                    style:  Theme.of(context).textTheme.headline6,
                                                    textAlign: TextAlign.left,
                                                  ),

                                                ),//Price
                                              ],
                                            ),
                                          ),

                                          //Seats Row
                                          Container(
                                            height: 60,
                                            color:  Theme.of(context).colorScheme.background,
                                            padding: EdgeInsets.only(left: size.width*0.06,right: size.width*0.06),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'How many seats?',
                                                  style:  Theme.of(context).textTheme.bodyText1,
                                                  textAlign: TextAlign.left,
                                                ),
                                                (model.rideTypeSelector)
                                                ?
                                                Container(
                                                  height: 60,
                                                  margin: EdgeInsets.only(top: 0),
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(0),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            height: 60,
                                                            child: (model.charge != null )? model.buildChips(context) : Container(),
                                                          ),
                                                        ],
                                                      )),
                                                  //SeatInputChip(key: UniqueKey(),),
                                                )
                                                    :
                                                Container(
                                                  width: 135,
                                                  height: 50,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(14.0),
                                                    color: Theme.of(context).colorScheme.surface,
                                                  ),

                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap:(){
                                                          model.decreaseCounter();
                                                        } ,
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(14.0),
                                                            color: Theme.of(context).colorScheme.background,
                                                          ),

                                                          child: Center(
                                                            child: Container(
                                                              height: 15,
                                                              width: 15,

                                                              child: SvgPicture.asset('assets/icons/countdecrease.svg'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      Container(
                                                        height: 40,
                                                        width: 45,
                                                        child:
                                                        Center(
                                                          child: Text("${(model.availableSeats == 0) ? 0 : model.passengerCount}",
                                                              style: Theme.of(context).textTheme.bodyText1
                                                          ),
                                                        ),
                                                      ),


                                                      GestureDetector(
                                                        onTap: (){
                                                          model.increaseCounter();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(14.0),
                                                            color: Theme.of(context).colorScheme.background,
                                                          ),

                                                          child: Center(
                                                            child: Container(
                                                              height: 15,
                                                              width: 15,

                                                              child: SvgPicture.asset('assets/icons/countincrease.svg'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          SizedBox(
                                            height: 5,),

                                          Container(
                                            color:  Theme.of(context).colorScheme.background,
                                            height: 30,
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.06,
                                                right: size.width * 0.06),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  height: 28,
                                                  child: RawMaterialButton(
                                                    onPressed: () async{

                                                      await model.navigateToPaymentOpt();

                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/icons/addpaymentflat.svg', color: Theme.of(context).colorScheme.primary,),
                                                        SizedBox(
                                                          width: 5,),
                                                        Container(
                                                          margin: EdgeInsets.only(left: 5),
                                                          child: Text(
                                                            'Pay with ${model.selectedProvider}',
                                                            style:  Theme.of(context).textTheme.subtitle1!.apply(color:  Theme.of(context).colorScheme.primary),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //TextRow
                                          Container(
                                            color:  Theme.of(context).colorScheme.background,
                                            height: 75,
                                          ), //Space to cover stack
                                        ],
                                      ),
                                    ),
                                  ),

                                  //Button
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                        width: size.width,
                                        height: 75,
                                        color:  Theme.of(context).colorScheme.background,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: size.width,
                                              child: Container(
                                                width: size.width * 0.88,
                                                margin: EdgeInsets.only(
                                                    left: size.width * 0.06,
                                                    right: size.width * 0.06),
                                                child:
                                                (model.charge != null )
                                                    ?
                                                Button(
                                                  child:
                                                  Row(
                                                    mainAxisAlignment:  MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "CONFIRM",
                                                        style:  Theme.of(context).textTheme.button,
                                                      ),
                                                    ],
                                                  ),
                                                  size: 45,
                                                  color:  Theme.of(context).colorScheme.secondary,
                                                  onPressed: () async{

                                                    await model.triggerConfirmTrip();

                                                  },
                                                )
                                                    :
                                                Button(
                                                  child:
                                                  Row(
                                                    mainAxisAlignment:  MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "CONFIRM",
                                                        style:  Theme.of(context).textTheme.button,
                                                      ),
                                                    ],
                                                  ),
                                                  size: 45,
                                                  color:  Theme.of(context).colorScheme.onSurface,
                                                )

                                              ),
                                            ),
                                          ],
                                        )),
                                  ),//Button Side
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Confirm Terminal
                        /*
                        Positioned(
                          bottom:0,
                          right:0,
                          child: AnimatedSize(
                            //vsync: this,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOutQuart,
                            child: Container(
                              height: model.confirmTerminalHeight,
                              width: size.width,
                              child: Stack(
                                children: [
                                  SlidingUpPanel(
                                    minHeight: 250,
                                    maxHeight: 250,
                                    renderPanelSheet: false,
                                    panel: Container(
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color:  Theme.of(context).colorScheme.background,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.onBackground.withOpacity(0.2) : Theme.of(context).colorScheme.onBackground.withOpacity(0.0),                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 30,
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.06,
                                                right: size.width * 0.06),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Confirm pickup spot',
                                                  style:  Theme.of(context).textTheme.headline6!.apply(color:  Theme.of(context).colorScheme.onBackground),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ), //TextRow

                                          Container(
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                              top: 10,
                                              bottom: 2,
                                            ),
                                            child:
                                            Container(
                                              height: 45,
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              decoration: BoxDecoration(
                                                color:  Theme.of(context).colorScheme.surface,
                                                borderRadius: BorderRadius.circular(15.00),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/busstop.svg'),
                                                  SizedBox(width: 15,),
                                                  Flexible(
                                                    child: Container(
                                                      padding: new EdgeInsets.only(right: 0),
                                                      child: Text(
                                                        '${(model.searchTripDetails != null) ? model.searchTripDetails.pickupName :'Pickup Terminal'}',
                                                        style:  Theme.of(context).textTheme.bodyText1,
                                                        textAlign: TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ), //TextRow //TextField
                                          SizedBox(height: 10,),
                                          Container(
                                            height: 20,
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.06,
                                                right: size.width * 0.06),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'This is the nearest bus stop',
                                                  style:  Theme.of(context).textTheme.subtitle1!.apply(color:  Theme.of(context).colorScheme.onSurface),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ), //TextRow
                                          Container(
                                            color:  Theme.of(context).colorScheme.background,
                                            height: 100,
                                          ), //Space to cover stack
                                        ],
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                        width: size.width,
                                        height: 75,
                                        color:  Theme.of(context).colorScheme.background,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: size.width,
                                              child: Container(
                                                width: size.width * 0.88,
                                                margin: EdgeInsets.only(
                                                    left: size.width * 0.06,
                                                    right: size.width * 0.06),
                                                child:
                                                Button(
                                                  child:
                                                  Row(
                                                    mainAxisAlignment:  MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "CONFIRM",
                                                        style:  Theme.of(context).textTheme.button,
                                                      ),
                                                    ],
                                                  ),
                                                  size: 45,
                                                  color:  Theme.of(context).colorScheme.secondary,
                                                  onPressed: () {

                                                    model.triggerConfirmTrip();
                                                  },
                                                ),

                                              ),
                                            ),
                                          ],
                                        )),
                                  ),//Button Side
                                ],
                              ),
                            ),
                          ),
                        ),

     */

                        //Ride Request Panel
                        Positioned(
                          bottom:0,
                          right:0,
                          child: AnimatedSize(
                            //vsync: this,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOutQuart,
                            child: Container(
                              height: model.requestRideHeight,
                              width: size.width,
                              child: Stack(
                                children: [
                                  SlidingUpPanel(
                                    minHeight: 240,
                                    maxHeight: 240,
                                    renderPanelSheet: false,
                                    panel: Container(
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color:  Theme.of(context).colorScheme.background,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.onBackground.withOpacity(0.2) : Theme.of(context).colorScheme.onBackground.withOpacity(0.0),                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 20,),
                                          Container(
                                            height: 30,
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.06,
                                                right: size.width * 0.06),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Requesting a ride...',
                                                  style:  Theme.of(context).textTheme.headline6,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ), //TextRow

                                          Container(
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                              top: 10,
                                              bottom: 2,
                                            ),
                                            height: 88,
                                            child:
                                            SpinKitPulse(color:  Theme.of(context).colorScheme.primary,size: 80.0,),
                                          ), //TextRow //TextField

                                          SizedBox(height: 5,),
                                          //TextRow
                                          Container(
                                            color: Theme.of(context).colorScheme.background,
                                            height: 85,
                                          ), //Space to cover stack
                                        ],
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                        width: size.width,
                                        height: 85,
                                        color:  Theme.of(context).colorScheme.background,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: size.width,
                                              child: Container(
                                                width: size.width * 0.88,
                                                margin: EdgeInsets.only(
                                                    left: size.width * 0.06,
                                                    right: size.width * 0.06),
                                                child: (model.allowCancel)
                                                    ?
                                                Button(
                                                  child:
                                                  Row(
                                                    mainAxisAlignment:  MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "CANCEL RIDE",
                                                        style:  Theme.of(context).textTheme.button,
                                                      ),
                                                    ],
                                                  ),
                                                  size: 45,
                                                  color:  Theme.of(context).colorScheme.error,
                                                  onPressed: () {

                                                    model.navigateToCancel();

                                                  },
                                                )
                                                    :
                                                Button(
                                                  child:
                                                  Row(
                                                    mainAxisAlignment:  MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "CANCEL RIDE",
                                                        style:  Theme.of(context).textTheme.button,
                                                      ),
                                                    ],
                                                  ),
                                                  size: 45,
                                                  color:  Theme.of(context).colorScheme.onSurface,

                                                )


                                              ),
                                            ),
                                          ],
                                        )),
                                  ),//Button Side
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Driver Arriving
                        Positioned(
                          bottom:0,
                          right:0,
                          child: AnimatedSize(
                            //vsync: this,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOutQuart,
                            child: Container(
                              height: model.driverPanelHeight,//driverPanelHeight,
                              width: size.width,
                              child: Stack(
                                children: [
                                  SlidingUpPanel(
                                    minHeight: 250,
                                    maxHeight: 250,
                                    renderPanelSheet: false,
                                    panel: Container(
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color:  Theme.of(context).colorScheme.background,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.onBackground.withOpacity(0.2) : Theme.of(context).colorScheme.onBackground.withOpacity(0.0),                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),

                                          Container(
                                            height: 25,
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.06,
                                                right: size.width * 0.06),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'ARRIVES IN ' + ((model.tripDetails != null) ? (model.tripDetails.wait_time).toString() : "0") + " MIN(S)",
                                                  style:  Theme.of(context).textTheme.bodyText1,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ), //TextRow //STATUS

                                          SizedBox(height: 5,),

                                          Container(
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                              top: 5,
                                              bottom: 2,
                                            ),
                                            height: 80,
                                            //color: Colors.grey,
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        (model.tripDetails != null) ? model.tripDetails.driverName : "Driver Name",
                                                        style:  Theme.of(context).textTheme.headline6!.apply(color:  Theme.of(context).colorScheme.primary),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      SizedBox(height: 3,),
                                                      Text(
                                                        (model.tripDetails != null) ? model.tripDetails.carColor +" "+model.tripDetails.carModel : "Car Description",
                                                        style:  Theme.of(context).textTheme.bodyText1!.apply(color:  Theme.of(context).colorScheme.onBackground),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      SizedBox(height: 3,),
                                                      Text(
                                                        (model.tripDetails != null) ? model.tripDetails.vehicleNumber : "Vehicle Number",
                                                        style:  Theme.of(context).textTheme.bodyText1!.apply(color:  Theme.of(context).colorScheme.onBackground),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //Profile
                                                Container(
                                                  height: 80,
                                                  width: 80,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 76,
                                                        width: 76,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.all(Radius.circular(30.0)), //add border radius here
                                                            child:
                                                            (model.tripDetails != null)
                                                               ?
                                                            Image.network(model.tripDetails.driverImageOriginal)
                                                            //model.tripDetails.driver_image_thumbnail
                                                                :
                                                            Image(image: AssetImage('assets/images/emptyprofile.png'), fit: BoxFit.fill)

                                                        ),)],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //Driver Details

                                          SizedBox(height: 5,),

                                          Container(
                                            height: 80,
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [

                                                //Call
                                                Container(
                                                  height: 80,
                                                  width: 90,
                                                  //color: Colors.grey,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                        child: RawMaterialButton(
                                                          onPressed: () async{
                                                            //HelperMethods.callPhone((Provider.of<AppData>(context, listen: false).tripDetails.phone));
                                                           model.callPhone();
                                                          },
                                                          shape: CircleBorder(),
                                                          child: SvgPicture.asset(
                                                              'assets/icons/iconphonecall.svg', color: Theme.of(context).colorScheme.onSurface),
                                                          padding: EdgeInsets.all(2.0),
                                                          elevation: 0,
                                                        ),
                                                      ),

                                                      SizedBox(height: 1,),

                                                      Text(
                                                        "Call",
                                                        style:  Theme.of(context).textTheme.subtitle2!.apply(color:  Theme.of(context).colorScheme.onSurface),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //Safety
                                                Container(
                                                  height: 80,
                                                  width: 90,
                                                  //color: Colors.grey,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        //margin: EdgeInsets.only(left: size.width * 0.05),
                                                        height: 50,
                                                        width: 50,
                                                        child: RawMaterialButton(
                                                          onPressed: () {
                                                            model.openTripSafetyBottomSheet();
                                                          },
                                                          shape: CircleBorder(),

                                                          child: SvgPicture.asset(
                                                              'assets/icons/iconsafety.svg' , color: Theme.of(context).colorScheme.onSurface),
                                                          padding: EdgeInsets.all(2.0),
                                                          elevation: 0,
                                                        ),
                                                      ),

                                                      SizedBox(height: 1,),
                                                      Text(
                                                        "Safety",
                                                        style:  Theme.of(context).textTheme.subtitle2!.apply(color:  Theme.of(context).colorScheme.onSurface),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //Cancel
                                                Container(
                                                  height: 80,
                                                  width: 90,
                                                  //color: Colors.grey,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        //margin: EdgeInsets.only(left: size.width * 0.05),
                                                        height: 50,
                                                        width: 50,
                                                        child: RawMaterialButton(
                                                          onPressed: () {

                                                            model.navigateToCancel();

                                                          },
                                                          shape: CircleBorder(),

                                                          child: SvgPicture.asset(
                                                              'assets/icons/iconcancelride.svg' ,color: Theme.of(context).colorScheme.onSurface),
                                                          padding: EdgeInsets.all(2.0),
                                                          elevation: 0,
                                                        ),
                                                      ),

                                                      SizedBox(height: 1,),
                                                      Text(
                                                        "Cancel",
                                                        style:  Theme.of(context).textTheme.subtitle2!.apply(color:  Theme.of(context).colorScheme.onSurface),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //TextRow with icons

                                          SizedBox(height: 5,),


                                          //Add note
                                          Container(
                                            //color: Colors.white,
                                            height: 20,
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.06,
                                                right: size.width * 0.06),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  //color: Colors.white,
                                                  //height: 30,
                                                  child: RawMaterialButton(
                                                    onPressed: () {

                                                      model.navigateToAddNote();
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/icons/cross-1.svg', height: 10, width: 10, color: Theme.of(context).colorScheme.primary,),
                                                        Container(
                                                          margin: EdgeInsets.only(left: 5),
                                                          child: Text(
                                                            'Add note for driver',
                                                            style:  Theme.of(context).textTheme.subtitle1!.apply(color:  Theme.of(context).colorScheme.primary),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),//Add note
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Trip Ongoing
                        Positioned(
                          bottom:0,
                          right:0,
                          child: AnimatedSize(
                            //vsync: this,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOutQuart,
                            child: Container(
                              height: 390,
                              width: size.width,
                              child: Stack(
                                children: [
                                  SlidingUpPanel(
                                    parallaxEnabled: true,
                                    minHeight: model.tripOngoingHeight,
                                    maxHeight: 370,
                                    renderPanelSheet: false,
                                    panel: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.background,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.onBackground.withOpacity(0.2) : Theme.of(context).colorScheme.onBackground.withOpacity(0.0),                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),

                                          Container(
                                            height: 30,
                                            margin: EdgeInsets.only(
                                                left: size.width * 0.06,
                                                right: size.width * 0.06),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "How's your ride going?",
                                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ), //TextRow //STATUS

                                          SizedBox(height: 10,),

                                          //Co-rider
                                          /*
                                    Container(
                                      height: 90,
                                        margin: EdgeInsets.only(
                                          left: size.width * 0.06,
                                          right: size.width * 0.06,
                                        ),
                                      //color: Colors.grey,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: (size.width-(size.width * 0.12))*0.6,
                                              child: Flexible(
                                                child: Text('Sharing a ride with Rafiya and Melchizedek',
                                                  style: ViellyThemeText_Medium_Grey_20,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: (size.width-(size.width * 0.12))*0.4,
                                              height: 60,
                                              //color: Colors.grey,
                                              child: Stack(children: [
                                                Positioned(
                                                  right: 50,
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: 60,
                                                          child: ClipRRect(
                                                              borderRadius: BorderRadius.all(Radius.circular(20.0)), //add border radius here
                                                              child: Image.network('https://cdn.cp.adobe.io/content/2/rendition/60b2528b-eb2a-4654-9af5-232e03134e34/artwork/3246162f-1673-46df-9c7d-30391deeb110/version/0/format/jpg/dimension/width/size/300')),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: 60,
                                                          child: ClipRRect(
                                                              borderRadius: BorderRadius.all(Radius.circular(20.0)), //add border radius here
                                                              child: Image.network('https://cdn.cp.adobe.io/content/2/rendition/60b2528b-eb2a-4654-9af5-232e03134e34/artwork/3246162f-1673-46df-9c7d-30391deeb110/version/0/format/jpg/dimension/width/size/300')),
                                                        ),

                                                        /*
                                                    Positioned(
                                                      right: 2,
                                                      bottom: 3,
                                                      child: Container(
                                                        width: 30.0,
                                                        height: 30.0,
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: ViellyThemeColor_blue,
                                                          border: Border.all(
                                                            width: 2.0,
                                                            color: ViellyThemeColor_whiteBack,
                                                          ),
                                                        ),
                                                        child: SvgPicture.asset('assets/icons/edit_avatar.svg',),
                                                      ),
                                                    ),

                                                     */
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],),
                                            ),
                                          ],
                                        )
                                    ), //Co-riders

                                     */

                                          //SizedBox(height: 5,),

                                          Container(
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                              top: 5,
                                              bottom: 2,
                                            ),
                                            height: 90,
                                            //color: Colors.grey,
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        (model.tripDetails != null) ? model.tripDetails.driverName : "Driver Name",
                                                        style:  Theme.of(context).textTheme.headline6!.apply(color:  Theme.of(context).colorScheme.primary),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      SizedBox(height: 3,),
                                                      Text(
                                                        (model.tripDetails != null) ? model.tripDetails.carColor +" "+model.tripDetails.carModel : "Car Description",
                                                        style:  Theme.of(context).textTheme.bodyText1!.apply(color:  Theme.of(context).colorScheme.onBackground),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      SizedBox(height: 3,),
                                                      Text(
                                                        (model.tripDetails != null) ? model.tripDetails.vehicleNumber : "Vehicle Number",
                                                        style:  Theme.of(context).textTheme.bodyText1!.apply(color:  Theme.of(context).colorScheme.onBackground),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //Profile
                                                Container(
                                                  height: 80,
                                                  width: 80,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 76,
                                                        width: 76,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.all(Radius.circular(30.0)), //add border radius here
                                                            child:
                                                            (model.tripDetails != null)
                                                                ?
                                                            Image.network('${model.tripDetails.driverImageThumbnail}')
                                                            //model.tripDetails.driver_image_thumbnail
                                                                :
                                                            Image(image: AssetImage('assets/images/emptyprofile.png'), fit: BoxFit.fill)

                                                        ),)],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //TextRow //Driver Details

                                          SizedBox(height: 5,),

                                          Container(
                                            height: 60,
                                            //color: Colors.grey,
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                            ),
                                            child:
                                            RawMaterialButton(
                                              onPressed: () {
                                                //showSafetyModal(size);
                                                //model.openTripSafetyBottomSheet();
                                                model.navigateToPayTrip();
                                              },
                                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(45.0)),
                                              child: Container(
                                                height: 60.00,
                                                width: 200.00,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Theme.of(context).colorScheme.surface,
                                                  ),
                                                  borderRadius: BorderRadius.circular(45.00),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(width: 3),
                                                    Text(
                                                      "Safety Tools",
                                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: SvgPicture.asset(
                                                          'assets/icons/safety.svg'),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        //color: Color(0xFFe0f2f1)
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ), //Safety Button

                                          SizedBox(height: 10,),

                                          Container(
                                            //color: Colors.grey,
                                            height: 35,
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Destination",
                                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  //(Provider.of<AppData>(context, listen: true).tripDetails != null) ? Provider.of<AppData>(context, listen: true).tripDetails.dropoff_location : " ",
                                                  (model.tripDetails != null) ? '${model.tripDetails.dropoffLocation }':'Location',
                                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ), //Destination

                                          SizedBox(height: 5,),

                                          Container(
                                            height: 35,
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  child: RawMaterialButton(
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {

                                                      model.navigateToPaymentOpt();
                                                    },
                                                    child: Text(
                                                      '${model.selectedProvider}',
                                                      style:  Theme.of(context).textTheme.bodyText1!.apply(color:  Theme.of(context).colorScheme.primary),
                                                      textAlign: TextAlign.left,
                                                        overflow: TextOverflow.ellipsis
                                                    ),
                                                  ),
                                                ),


                                                Text(
                                                  //(Provider.of<AppData>(context, listen: true).tripDetails != null) ? ('GHC ' + (Provider.of<AppData>(context, listen: true).tripDetails.charge).toString()) : " ",
                                                  (model.tripDetails != null) ? 'GHC ${(model.charge).toStringAsFixed(2)}' : 'GHC 0.00',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                    textAlign: TextAlign.right,
                                                    overflow: TextOverflow.ellipsis
                                                ),
                                              ],
                                            ),
                                          ),//Trip fare
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Bus Trip Ongoing
                        Positioned(
                          bottom:0,
                          right:0,
                          child: AnimatedSize(
                            //vsync: this,
                            duration: new Duration(milliseconds: 500),
                            curve: Curves.easeInOutQuart,
                            child: Container(
                              height: 400,
                              width: size.width,
                              child: Stack(
                                children: [
                                  SlidingUpPanel(
                                    parallaxEnabled: true,
                                    minHeight: model.busTripOngoingHeight,
                                    maxHeight: 400,
                                    renderPanelSheet: false,
                                    panel: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      //width: size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.background,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.onBackground.withOpacity(0.2) : Theme.of(context).colorScheme.onBackground.withOpacity(0.0),                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 15,),



                                          SizedBox(height: 10,),

                                          //SizedBox(height: 5,),

                                          Container(
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                              top: 5,
                                              bottom: 2,
                                            ),
                                            height: 90,
                                            //color: Colors.grey,
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                //Bus Details
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        (model.ticketDetails != null) ? model.ticketDetails.busDriverName : "Driver Name",
                                                        style:  Theme.of(context).textTheme.headline6!.apply(color:  Theme.of(context).colorScheme.primary),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      SizedBox(height: 3,),
                                                      Text(
                                                        (model.ticketDetails != null) ? model.ticketDetails.busColor +" "+model.ticketDetails.busModel : "Car Description",
                                                        style:  Theme.of(context).textTheme.bodyText1!.apply(color:  Theme.of(context).colorScheme.onBackground),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      SizedBox(height: 3,),
                                                      Text(
                                                        (model.ticketDetails != null) ? model.ticketDetails.busVehicleNumber : "Bus Number",
                                                        style:  Theme.of(context).textTheme.bodyText1!.apply(color:  Theme.of(context).colorScheme.onBackground),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //Profile
                                                Container(
                                                  height: 80,
                                                  width: 80,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 76,
                                                        width: 76,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.all(Radius.circular(30.0)), //add border radius here
                                                            child:
                                                            (model.ticketDetails != null)
                                                                ?
                                                            Image.network('${model.ticketDetails.busDriverProfileThumb}')
                                                            //model.tripDetails.driver_image_thumbnail
                                                                :
                                                            Image(image: AssetImage('assets/images/emptyprofile.png'), fit: BoxFit.fill)

                                                        ),)],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), //TextRow //Driver Details

                                          SizedBox(height: 10,),

                                          //Show ticket button
                                          Container(
                                            width: size.width,

                                            height: 50,
                                            child: Center(
                                              child: Container(
                                                  width: size.width * 0.88,
                                                  margin: EdgeInsets.only(
                                                      left: size.width * 0.06,
                                                      right: size.width * 0.06),
                                                  child: Button(
                                                    child:
                                                    Row(
                                                      mainAxisAlignment:  MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "${AppLocalizations.of(context)!.showTicket}",
                                                          style: Theme.of(context).textTheme.button,
                                                        ),
                                                      ],
                                                    ),
                                                    size: 45,
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    onPressed: () async{
                                                      await model.showTicket();
                                                    },
                                                  )//CREATE ENABLED

                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 20,),

                                          Container(
                                            height: 60,
                                            width: 250,
                                            //color: Colors.grey,
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                            ),
                                            child:
                                            SizedBox(
                                              child: RawMaterialButton(
                                                constraints: BoxConstraints(),
                                                onPressed: () {
                                                  //showSafetyModal(size);
                                                  model.openTripSafetyBottomSheet();

                                                },
                                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(45.0)),
                                                child: Container(
                                                  padding: EdgeInsets.all(10.0),
                                                  width: 250.00,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 2,
                                                      color: Theme.of(context).colorScheme.surface,
                                                    ),
                                                    borderRadius: BorderRadius.circular(45.00),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SizedBox(width: 3),
                                                      Text(
                                                        "${AppLocalizations.of(context)!.safetyTools}",
                                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      Container(
                                                        width: 40,
                                                        height: 40,
                                                        child: SvgPicture.asset(
                                                            'assets/icons/safety.svg'),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          //color: Color(0xFFe0f2f1)
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ), //Safety Button

                                          SizedBox(height: 10,),

                                          Container(
                                            //color: Colors.grey,
                                            height: 35,
                                            margin: EdgeInsets.only(
                                              left: size.width * 0.06,
                                              right: size.width * 0.06,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "${AppLocalizations.of(context)!.destination}",
                                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  //(Provider.of<AppData>(context, listen: true).tripDetails != null) ? Provider.of<AppData>(context, listen: true).tripDetails.dropoff_location : " ",
                                                  (model.ticketDetails != null) ? '${model.ticketDetails.dropOffTerminalName }':'Location',
                                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ), //Destination

                                          //End Track button
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                                            width: size.width,
                                            height: 45,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.1)),

                                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
                                              onPressed: (){

                                                model.getNavigator.back();

                                              },
                                              child: Text(
                                                '${AppLocalizations.of(context)!.goBack}',
                                                style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                                              ),
                                            ),
                                          ),

                                        ],
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
                  //Transparency at top
                ],
              ),
            ),
          ),
    );
  }
}



