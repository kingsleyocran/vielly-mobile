import 'dart:convert';

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
import '../../../../data/models/user.dart';
import 'dotted_line_separator.dart';


class Ticket extends StatefulWidget {
  final TicketDetails ticketDetails;
  final UserDetails userProfile;
  final Function function;

  Ticket({
    required this.ticketDetails,
    required this.userProfile,
    required this.function,
  });
  @override
  _TicketCardState createState() => _TicketCardState();
}

class _TicketCardState extends State<Ticket> {
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


    var date = DateFormat('yMd').parse((widget.ticketDetails.dateOfOrder).toString());

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
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [

            //Ticket Code
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child:
                Text("${widget.ticketDetails.ticketNumber}",
                  style: Theme.of(context).textTheme.headline6!.apply(color: Colors.white),
                ),
              ),
            ),

            SizedBox(
              height: 3,),

            //Bus Lane
            Container(
              height: 45,

              child: Center(
                child:
                Text("${widget.ticketDetails.laneName}",
                  style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),

            //Price and Date
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              //height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Container(


                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Center(
                      child: Text(Localizations.localeOf(context).languageCode != "fr" ? 'GHC' " ${widget.ticketDetails.charge}" : 'CFA' " ${widget.ticketDetails.charge}",
                        style: Theme.of(context).textTheme.headline6!.apply(color: Colors.white,),
                      ),
                    ),
                  ),

                  Container(
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        SizedBox(height: 3,),
                        Text("${DateFormat('EEE - d MMM, yyyy', Localizations.localeOf(context).languageCode).format(DateFormat('yMd').parse((widget.ticketDetails.dateOfOrder).toString()))}",
                          style: Theme.of(context).textTheme.bodyText2!.apply(color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(height: 2,),
                        Text("${widget.ticketDetails.bookingTime}",
                          style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 5,),

            //Location
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 18),
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

            //Passenger and Seat
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${AppLocalizations.of(context)!.passengerName}",
                          style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(height: 5,),
                        Text("${widget.userProfile.name}",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${AppLocalizations.of(context)!.seats}",
                          style: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(height: 5,),
                        Text("${widget.ticketDetails.passengerCount}",
                          style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,),

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

            //QR
            Container(
              height: 140,
              child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  color: Colors.white,
                  child:  Image.memory(
                    base64Decode(widget.ticketDetails.qrCode!.replaceFirst("data:image/png;base64,", "")),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 5,),
          ],
        ),
      ),
    );
  }
}
