
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../data/models/ticket.dart';
import '../../../../presentation/widgets/custom_widgets/button.dart';
import 'bus_ride_trip_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';



class BusRideView extends StatefulWidget {
  final TicketDetails? ticketDetails;

  const BusRideView({
    Key? key,
    this.ticketDetails
  }) : super(key: key);


  @override
  _BusRideViewState createState() => _BusRideViewState();
}

class _BusRideViewState extends State<BusRideView> with TickerProviderStateMixin{

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

    return ViewModelBuilder<BusRideViewModel>.reactive(

      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      fireOnModelReadyOnce: true,

      onModelReady: (model) async{ await model.initialiseOnModelReady(context, widget.ticketDetails);},


      viewModelBuilder: () => BusRideViewModel(),
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
                    bottom: false,
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
                                  model.tripPolylineFocus();

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
                                if(model.ticketDetails != null)
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
                                if(model.ticketDetails != null){
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

                                                              '${(model.ticketDetails != null)
                                                                  ?model.ticketDetails.pickupTerminalName
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
                                                              '${(model.ticketDetails != null)
                                                                  ?model.ticketDetails.dropOffTerminalName
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
                                  model.getNavigator.back();
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

                        //Trip Ongoing
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
                                    minHeight: model.tripOngoingHeight,
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
                                                  model.openTripSafetyBottomSheet(context);

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
                  //Tranparency at top
                ],
              ),
            ),
          ),
    );
  }
}



