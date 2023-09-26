import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';


import '../../../app/app.locator.dart';
import '../../../data/models/busschedule_data.dart';
import 'button.dart';



class BusScheduleCard extends StatefulWidget {
  final BusSchedule busSchedule;
  final Function function;

  BusScheduleCard({
    required this.busSchedule,
    required this.function,
  });

  @override
  _BusScheduleCardState createState() => _BusScheduleCardState();
}

class _BusScheduleCardState extends State<BusScheduleCard> {
  final ThemeService _themeService = locator<ThemeService>();

  ThemeService get getTheme => _themeService;

  //((model.userProfile.name).split(' '))[0];
  
  String? _dayNightSVG;
  String _setImage(String time) {
    if(time == "AM") {
      _dayNightSVG = "assets/icons/sun.svg";
    } else if(time == "PM") {
      _dayNightSVG = "assets/icons/moon.svg";
    }

    return _dayNightSVG!; // here it returns your _backgroundImage value
  }

   



  void dateFormat(){


    var date = DateFormat('yMd').parse((widget.busSchedule.date).toString());

    //var date = DateTime.now();
    print(date.toString()); // prints something like 2019-12-10 10:02:22.287949
    print(DateFormat('EEEE').format(date)); // prints Tuesday
    print(DateFormat('EEEE - d MMM, yyyy').format(date)); // prints Tuesday, 10 Dec, 2019
    print(DateFormat('h:mm a').format(date));

  }

  DateFormat? dateFormatting;
  DateFormat? timeFormat;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeDateFormatting();

    dateFormatting = new DateFormat.yMMMMd();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 190,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      margin: EdgeInsets.only(top: 20, left: size.width*0.04, right: size.width*0.04,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //Sun or Moon Icon
          Container(
            width: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2,),
                SvgPicture.asset(
                    _setImage(((widget.busSchedule.time)!.split(' '))[4])),
              ],
            ),
          ),


          Expanded(

            child: Container(
              child: Column(
                children: [

                  //Depature Date and Time
                  Container(
                    height: 50,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //Departure Date
                        Container(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.departureTime,
                                style:
                                (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                    ?
                                Theme.of(context).textTheme.overline!.apply(color: Theme.of(context).colorScheme.onError)
                                    :
                                Theme.of(context).textTheme.overline!.apply(color: Theme.of(context).colorScheme.onError),
                              ),
                              SizedBox(height: 7,),
                              Text(
                                "${DateFormat('EEE - d MMM, yyyy', Localizations.localeOf(context).languageCode).format(DateFormat('yMd').parse((widget.busSchedule.date).toString()))}",
                                style:

                                Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onError),
                              ),
                            ],
                          ),
                        ),

                        //Time
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9.0),
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Center(
                                  child: Text("${widget.busSchedule.time}",
                                    style:
                                    (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                        ?
                                    Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.onError)
                                        :
                                    Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.onError),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Divider
                  Container(
                    //margin: EdgeInsets.symmetric(horizontal: size.width*0.06,),

                    child: Divider(
                      color: Theme.of(context).colorScheme.surface,
                      height: 5,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                  ),

                  SizedBox(height: 10,),

                  //BUS LANE
                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          height: 60,
                          child: SvgPicture.asset(
                              'assets/icons/buscardLocations.svg'),
                        ),

                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text("${widget.busSchedule.startTerminal}",
                                  style:

                                  Theme.of(context).textTheme.bodyText1,
                                ),
                                Text("${widget.busSchedule.endTerminal}",
                                  style:
                                  Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5,),

                  //Button Row
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child:
                          Text("${AppLocalizations.of(context)!.availableSeats} - ${widget.busSchedule.seats}",
                            style:
                            Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onBackground),
                          ),
                        ),

                        //Button
                        Container(
                          width: 120,
                          child: Center(
                            child: Button(
                              child:
                              Container(
                                child: Text(
                                  AppLocalizations.of(context)!.bookNow,
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Theme.of(context).colorScheme.background),
                                ),
                              ),
                              size: 40,
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {


                                widget.function();
                                print(widget.busSchedule.busID);

                              },
                            ),
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
    );
  }
}



class BusScheduleEmptyCard extends StatelessWidget {
  final ThemeService _themeService = locator<ThemeService>();

  ThemeService get getTheme => _themeService;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 190,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      margin: EdgeInsets.only(top: 20, left: size.width*0.04, right: size.width*0.04,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //Sun or Moon Icon
          Container(
            width: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                )
              ],
            ),
          ),


          Expanded(

            child: Container(
              child: Column(
                children: [

                  //Depature Date and Time
                  Container(
                    height: 50,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //Departure Date
                        Container(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 15,
                                width: 120,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).colorScheme.surface,
                                ),

                              ),

                              SizedBox(height: 10,),
                              Container(
                                height: 20,
                                width: 170,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Theme.of(context).colorScheme.surface,
                                ),

                              ),
                            ],
                          ),
                        ),

                        //Time
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 30,
                                width: 100,
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Theme.of(context).colorScheme.surface,
                                ),

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Divider
                  Container(
                    //margin: EdgeInsets.symmetric(horizontal: size.width*0.06,),

                    child: Divider(
                      color: Theme.of(context).colorScheme.surface,
                      height: 5,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                  ),

                  SizedBox(height: 10,),

                  //BUS LANE
                  Container(
                    height: 60,
                    child: Row(
                      children: [

                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Container(
                                  height: 25,
                                  width: 240,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Theme.of(context).colorScheme.surface,
                                  ),

                                ),
                                SizedBox(height: 3,),
                                Container(
                                  height: 25,
                                  width: 180,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Theme.of(context).colorScheme.surface,
                                  ),

                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5,),

                  //Button Row
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          width: 110,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).colorScheme.surface,
                          ),

                        ),

                        //Button
                        Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).colorScheme.surface,
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
    );
  }
}