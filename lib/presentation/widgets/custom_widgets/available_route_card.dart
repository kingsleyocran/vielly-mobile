import 'dart:developer';

import 'package:curve/data/models/busschedule_data.dart';
import 'package:curve/data/models/busterminals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../app/app.locator.dart';
import '../../../../data/models/ticket.dart';
import 'dotted_line_separator.dart';

//import '../../../app/locator.dart';
//import '../../../data/models/ticket.dart';



class AvailableRouteCard extends StatefulWidget {
  final BusSchedule busSchedule;
  final Function function;

  AvailableRouteCard({
    required this.busSchedule,
    required this.function,
  });
  @override
  _AvailableRouteCardState createState() => _AvailableRouteCardState();
}
class _AvailableRouteCardState extends State<AvailableRouteCard> {
  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;




  late String? busTerms = formatString(widget.busSchedule.busTerminal);

  String formatString(List<BusTerminal>? busTerminal) {
    String formatted ='';
    for(int i = 0; i< busTerminal!.length; i++) {
      formatted += '${busTerminal[i].busTerminalName}, ';
    }
    return formatted.replaceRange(formatted.length -2, formatted.length, '');
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 22),
      child: GestureDetector(
        onTap: (){
          widget.function();
        },
        child: Container(
          //height: 190,
          margin: EdgeInsets.only(left: size.width*0.06, right: size.width*0.06,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).colorScheme.background,
          ),

          child: Container(
            child: Column(
              children: [

                SizedBox(height: 7,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 90,
                    //margin: EdgeInsets.symmetric(horizontal: 18),
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
                                      Expanded(
                                        child: Text("${widget.busSchedule.startTerminal}",
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

                                      Expanded(

                                        child: Text("${widget.busSchedule.endTerminal}",
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
                ),

                //Dotted Line & Cutout
                Container(
                  child: Row(
                    children: [

                      //Dotted Line
                      Expanded(
                        child: DottedLine(height: 2, width: 7, color: Theme.of(context).colorScheme.surface,),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 7,),

                //Bus Terminals
                Container(

                  padding: EdgeInsets.symmetric(horizontal: 15),

                  height: 35,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      //Departure Date
                      Flexible(
                        child: Container(
                          child: Text(
                            "$busTerms",
                            style:
                            Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onError),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 7,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class AvailableRouteEmptyCard extends StatelessWidget {
  final ThemeService _themeService = locator<ThemeService>();

  ThemeService get getTheme => _themeService;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 22),
      child: Container(
        //height: 190,
        margin: EdgeInsets.only(left: size.width*0.06, right: size.width*0.06,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).colorScheme.background,
        ),

        child: Container(
          child: Column(
            children: [

              SizedBox(height: 7,),
              Container(
                height: 90,
                //margin: EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color:
                  Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(15),
                //color: Colors.redAccent,
                child: Row(
                  children: [

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
                                  Container(
                                    width: 170,
                                    height: 25,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Theme.of(context).colorScheme.surface,
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

                                  Container(
                                    width: 220,
                                    height: 25,

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
                    ),
                  ],
                ),
              ),

              //Dotted Line & Cutout
              Container(
                child: Row(
                  children: [

                    //Dotted Line
                    Expanded(
                      child: DottedLine(height: 2, width: 7, color: Theme.of(context).colorScheme.surface,),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 7,),

              //Bus Terminals
              Container(

                padding: EdgeInsets.symmetric(horizontal: 15),

                height: 35,


                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                      width: 150,
                      height: 25,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 7,),
            ],
          ),
        ),
      ),
    );
  }
}