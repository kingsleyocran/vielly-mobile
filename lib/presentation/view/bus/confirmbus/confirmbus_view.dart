import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../configurations/colors.dart';
import '../../../widgets/custom_widgets/button.dart';
import '../../../../app/app.locator.dart';
import 'confirmbus_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';


class ConfirmBusView extends StatelessWidget {
  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<ConfirmBusViewModel>.reactive(
      viewModelBuilder: () => ConfirmBusViewModel(),
      onModelReady: (model)async{await model.initialized();},
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
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SafeArea(bottom: false,child: Container(height: 62,)),

                              //CONTENT GOES HERE
                              SizedBox(height: 10,),
                              Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.08,
                                ),
                                width: size.width,
                                decoration: BoxDecoration(
                                  color:
                                  Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      //Bus Lane
                                      Container(
                                        height: 30,
                                        //color: Colors.grey,
                                        child: Center(
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text("${(('${model.bookedBusData.laneName}').toUpperCase())}",
                                                    overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context).textTheme.headline5
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 15,),

                                      //Ticket Price
                                      Container(
                                        height: 55,
                                        //color: Colors.amberAccent,

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            Container(
                                              child:
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("${AppLocalizations.of(context)!.ticketPrice}",
                                                    style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(14.0),
                                                color: ThemeColor_green,
                                              ),
                                              child: Center(
                                                child: Text("${(Localizations.localeOf(context).languageCode != "fr" ? 'GHC' : 'CFA')} ${model.bookedBusData.charge??''}",
                                                  style: Theme.of(context).textTheme.headline6!.apply(color: ThemeColor_white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 15,),

                                      //Location Pickup & Drop
                                      Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color:
                                          Theme.of(context).colorScheme.background,
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        padding: EdgeInsets.all(15),
                                        //color: Colors.redAccent,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              height: 80,

                                              child: SvgPicture.asset(
                                                  'assets/icons/busstarttodrop.svg'),
                                            ),

                                            SizedBox(width: 10,),

                                            Expanded(
                                              child: Container(
                                                height: 75,

                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text("${AppLocalizations.of(context)!.pickUp} - ",
                                                            style: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                                                ?
                                                            Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface)
                                                                :
                                                            Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),

                                                          ),
                                                          Expanded(
                                                            child: Text("${model.bookedBusData.pickupTerminal.busTerminalName??''}",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                                                  ?
                                                              Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError)
                                                                  :
                                                              Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError),

                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text("${AppLocalizations.of(context)!.dropOff} - ",
                                                            style: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                                                ?
                                                            Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface)
                                                                :
                                                            Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                          ),
                                                          Expanded(
                                                            child: Text("${model.bookedBusData.dropOffTerminal.busTerminalName??''}",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                                                  ?
                                                              Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError)
                                                                  :
                                                              Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError),

                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 15,
                                      ),

                                      //Date and Time
                                      Container(
                                        height: 15,
                                        //color: Colors.lightBlueAccent,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [

                                                Container(
                                                  height: 10,
                                                  width: 10,

                                                  child: SvgPicture.asset(
                                                      'assets/icons/calendar.svg', color: Theme.of(context).colorScheme.onSurface,),
                                                ),

                                                SizedBox(width: 5,),

                                                Text("${(DateFormat('d MMM, yyyy' , Localizations.localeOf(context).languageCode).format(DateFormat('yMd').parse(model.bookedBusData.date)))}",
                                                  style:(getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                                      ?
                                                  Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.onError)
                                                      :
                                                  Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.onError),

                                                ),

                                              ],
                                            ),

                                            Row(
                                              children: [

                                                Container(
                                                  height: 10,
                                                  width: 10,


                                                  child: SvgPicture.asset(
                                                      'assets/icons/time.svg', color: Theme.of(context).colorScheme.onSurface,),
                                                ),

                                                SizedBox(width: 5,),

                                                Text("${(model.bookedBusData.time)??''}",
                                                  style:
                                                  (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                                      ?
                                                  Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.onError)
                                                      :
                                                  Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.onError),

                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 20,),

                              //Seats
                              Container(
                                //color: Colors.amberAccent,
                                height: 50,
                                margin: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.08,
                                ),
                                width: size.width,

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${AppLocalizations.of(context)!.howManySeats}",
                                      style:
                                      (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                          ?
                                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError)
                                          :
                                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError)
                                    ),

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
                                              child: Text("${(model.bookedBusData.availableSeats == 0) ? 0 : model.passengerCount}",
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
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20,),

                              //No seats message
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: size.width *0.06),
                                child: (model.bookedBusData.availableSeats == 0)
                                  ? Text("${AppLocalizations.of(context)!.thereNoSeats}",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.error))
                                  : null,
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
                                          '${AppLocalizations.of(context)!.busTripDetails}',
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

                          //Button
                          height: 70,
                          color: Theme.of(context).colorScheme.background,
                          child: Center(
                            child: Container(
                                width: size.width * 0.88,
                                margin: EdgeInsets.only(
                                    left: size.width * 0.06,
                                    right: size.width * 0.06),
                                child: (true)
                                    ?
                                Button(
                                  child:
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (model.bookedBusData.availableSeats == 0)?'${AppLocalizations.of(context)!.goBack}':"${AppLocalizations.of(context)!.bookNow}",
                                        style: Theme.of(context).textTheme.button,
                                      ),
                                    ],
                                  ),
                                  size: 45,
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () async{
                                    if(model.bookedBusData.availableSeats == 0){
                                      model.getNavigator.popRepeated(2);
                                    }else{
                                      await model.confirmBusTrip();
                                    }

                                  },
                                )
                                    :
                                Button(
                                  child:
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${AppLocalizations.of(context)!.bookNow}",
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
    );
  }
}



