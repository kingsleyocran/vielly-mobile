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



class TicketCard extends StatefulWidget {
  final TicketDetails ticketDetails;
  final Function function;

  TicketCard({
    required this.ticketDetails,
    required this.function,
  });
  @override
  _TicketCardState createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  final ThemeService _themeService = locator<ThemeService>();

  ThemeService get getTheme => _themeService;

  /*
  String _dayNightSVG;
  String _setImage(String time) {
    if(time == "mtn") {
      _dayNightSVG = "assets/icons/sun.svg";
    } else if(time == "vodafone") {
      _dayNightSVG = "assets/icons/moon.svg";
    }

    return _dayNightSVG; // here it returns your _backgroundImage value
  }

   */

  void dateFormat(){


    var date = DateFormat('yMd').parse((widget.ticketDetails.dateOfOrder)!);

    //var date = DateTime.now();
    print(date.toString()); // prints something like 2019-12-10 10:02:22.287949
    print(DateFormat('EEEE').format(date)); // prints Tuesday
    print(DateFormat('EEEE - d MMM, yyyy').format(date)); // prints Tuesday, 10 Dec, 2019
    print(DateFormat('h:mm a').format(date));

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

            /*
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],

             */
          ),
          child: Container(
            child: Column(
              children: [

                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(17),
                      topLeft: Radius.circular(17),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child:
                          Text("${widget.ticketDetails.ticketNumber}",
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.headline6!.apply(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      //Bus Lane
                      Container(
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child:
                                Text("${(widget.ticketDetails.laneName)!.toUpperCase()}",
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onBackground),
                                ),
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

                      SizedBox(height: 7,),

                      //Location
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
                                          Text("${AppLocalizations.of(context)!.pickUp}- ",
                                            style: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                                ?
                                            Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface)
                                                :
                                            Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),

                                          ),

                                          Expanded(
                                            child: Text("${widget.ticketDetails.pickupTerminalName}",
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

                                            child: Text("${widget.ticketDetails.dropOffTerminalName}",
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



                    ],
                  ),
                ),

                //Dotted Line & Cutout
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: SvgPicture.string(
// Intersection 1
                          '<svg viewBox="330.0 438.0 14.0 26.0" ><path transform="matrix(-1.0, 0.0, 0.0, -1.0, 344.0, 464.0)" d="M 0 12.99960041046143 C 0 5.820300102233887 5.820300102233887 0 12.99960041046143 0 C 13.33617210388184 0 13.67026424407959 0.01282436586916447 14.00040054321289 0.03794235736131668 L 14.00040054321289 25.9621467590332 C 13.67026424407959 25.98726654052734 13.33617210388184 26.00010108947754 12.99960041046143 26.00010108947754 C 5.820300102233887 26.00010108947754 0 20.17980003356934 0 12.99960041046143 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          width: 14.0,
                          height: 26.0,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),

                      //Dotted Line
                      Expanded(
                        child: DottedLine(height: 2, width: 7, color: Theme.of(context).colorScheme.surface,),
                      ),

                      Container(
                        child: SvgPicture.string(
// Intersection 1
                          '<svg viewBox="330.0 438.0 14.0 26.0" ><path transform="translate(2246.0, -796.0)" d="M -1916.000122070313 1247.001342773438 C -1916.000122070313 1239.821166992188 -1910.179809570313 1234.000854492188 -1902.999633789063 1234.000854492188 C -1902.6630859375 1234.000854492188 -1902.329833984375 1234.013549804688 -1901.999755859375 1234.038696289063 L -1901.999755859375 1259.963012695313 C -1902.329833984375 1259.988159179688 -1902.6630859375 1260.0009765625 -1902.999633789063 1260.0009765625 C -1910.179809570313 1260.0009765625 -1916.000122070313 1254.1806640625 -1916.000122070313 1247.001342773438 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          width: 14.0,
                          height: 26.0,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                ),


                SizedBox(height: 7,),

                //Depature Date and Time
                Container(

                  padding: EdgeInsets.symmetric(horizontal: 15),

                  height: 35,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      //Departure Date
                      Container(
                        child: Text(
                          "${DateFormat('EEE - d MMM, yyyy', Localizations.localeOf(context).languageCode).format(DateFormat('yMd').parse((widget.ticketDetails.dateOfOrder).toString()))}",
                          style:

                          Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onError),
                        ),
                      ),

                      //Time
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.all(7),
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.0),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Center(
                                child: Text("${widget.ticketDetails.bookingTime}",
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

                SizedBox(height: 7,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketEmptyCard extends StatelessWidget {
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