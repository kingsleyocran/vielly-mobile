import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../data/models/busschedule_data.dart';
import '../../../../enums/enums.dart';
import '../../../../presentation/widgets/custom_widgets/button.dart';
import '../../../../presentation/widgets/custom_widgets/loading_screen.dart';
import '../../../../presentation/widgets/custom_widgets/onfailed_screen.dart';
import '../../../../app/app.locator.dart';
import 'bustripdetails_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';


class BusTripDetailsView extends StatefulWidget {
  final BusSchedule? schedule;
  final BusSchedule? busSchedule;
  final List<BusSchedule>? busScheduleList;

  const BusTripDetailsView({
    Key? key,
    this.schedule,
    this.busSchedule,
    this.busScheduleList
  })  : super(key: key);


  @override
  _BusTripDetailsViewState createState() => _BusTripDetailsViewState();
}

class _BusTripDetailsViewState extends State<BusTripDetailsView> {


  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<BusTripDetailsViewModel>.reactive(
      viewModelBuilder: () => BusTripDetailsViewModel(),

      onModelReady: (model) { model.initializer(valueSch: widget.schedule, value: widget.busSchedule, valueList: widget.busScheduleList); },

      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body:
              Container(
                height: size.height,
                child: Stack(

                  children: [
                    //Content
                    (model.loadingState == LoadingState.fetched)
                        ?
                    SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SafeArea(
                            bottom: false,
                              child: Container(height: 62,)),

                          //CONTENT GOES HERE
                          Container(
                              width: size.width,

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [

                                        //Entries
                                        Container(
                                          width: size.width,
                                          margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 5,),

                                              //Bus Lane
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        AppLocalizations.of(context)!.busLane,
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

                                                              if(model.busSchedule == null || model.scheduleDetails==null) {
                                                                model.openLaneBottomSheet();
                                                                print (model.busScheduleList);
                                                              }
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
                                                                  Text((model.busSchedule==null || model.scheduleDetails==null)?(model.selectedLane??'${AppLocalizations.of(context)!.selectBusLane }'):(widget.busSchedule!.laneName),
                                                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
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

                                              SizedBox(
                                                height: 20,
                                              ),

                                              //Pick-up Point
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        '${AppLocalizations.of(context)!.pickupTerminal}',
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

                                                              model.openPickupBottomSheet();
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
                                                                  Text((model.selectedPickupTerminal??'${AppLocalizations.of(context)!.selectPickupTerminal}'),
                                                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
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

                                              SizedBox(
                                                height: 20,
                                              ),

                                              //Drop-off Point
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        '${AppLocalizations.of(context)!.dropOffTerminal}',
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

                                                              model.openDropOffBottomSheet();
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
                                                                  Text((model.selectedDropOffTerminal??'${AppLocalizations.of(context)!.selectDropOffTerminal}'),
                                                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
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

                                              SizedBox(
                                                height: 20,
                                              ),

                                              //Date
                                              (false) //(model.busSchedule == null || (model.scheduleDetails == null))
                                                  ?
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        AppLocalizations.of(context)!.date,
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

                                                              model.openDateBottomSheet();
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
                                                                  Text((model.selectedDateConverted??'${AppLocalizations.of(context)!.selectDate}'),
                                                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
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
                                              ) : Container(),

                                              SizedBox(
                                                height: 20,
                                              ),

                                              //Time Duration
                                              (false) //(model.busSchedule == null || (model.scheduleDetails == null))
                                                  ?
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        AppLocalizations.of(context)!.busTripTime,
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

                                                              model.openTimeBottomSheet();
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
                                                                  Text((model.selectedTime??'${AppLocalizations.of(context)!.selectTimeDuration}'),
                                                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
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
                                              ) : Container(),

                                              SafeArea(top: false,bottom: true, child: Container(height: 0,)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              )
                          )



                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                )
                        :
                    (model.loadingState == LoadingState.onFailed)
                        ?
                      OnFailedScreen(
                        onRetryFunction: ()async{
                          model.initializer(value: widget.busSchedule, valueList: widget.busScheduleList);
                        },
                      )
                        :
                      LoadingScreen(),


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
                                child:
                                Container(
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
                                            model.getNavigator.back();
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
                                          AppLocalizations.of(context)!.searchBus,
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
                    ),

                    //Button
                    Positioned(
                      bottom: 0,
                      child: (model.loadingState == LoadingState.fetched)
                          ?
                      SafeArea(
                        top: false,
                        child: Container(
                          width: size.width,
                          height: 70,
                          color: Theme.of(context).colorScheme.background,
                          child: Center(
                            child:
                            Container(
                                width: size.width * 0.88,
                                margin: EdgeInsets.only(
                                    left: size.width * 0.06,
                                    right: size.width * 0.06),
                                child: (model.selectedLane != null && model.selectedPickupTerminalID != null && model.selectedDropOffTerminalID != null && model.selectedDate != null && model.selectedTime != null)
                                    ?
                                Button(
                                  child:
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.confirm,
                                        style: Theme.of(context).textTheme.button,
                                      ),
                                    ],
                                  ),
                                  size: 45,
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () async{
                                    //model.navigateToBusDetails();
                                    await model.bookBusTrip();
                                  },
                                )//ENABLED
                                    :
                                Button(
                                  child:
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.confirm,
                                        style: Theme.of(context).textTheme.button,
                                      ),
                                    ],
                                  ),
                                  size: 45,
                                  color: Theme.of(context).colorScheme.onSurface,

                                )//DISABLED BUTTON
                            ),
                          ),
                        ),
                      ) :
                      Container()
                    ),


                  ],
                ),
              ),
            ),
          ),
    );
  }
}



