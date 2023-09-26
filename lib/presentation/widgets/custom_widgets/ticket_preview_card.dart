import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

import '../../../data/models/ticket.dart';
import '../../../../app/app.locator.dart';


class TicketPreviewCard extends StatefulWidget {
  final TicketDetails ticketDetails;
  final Function function;

  TicketPreviewCard({
    required this.ticketDetails,
    required this.function,
  });

  @override
  _TicketPreviewCardState createState() => _TicketPreviewCardState();
}

class _TicketPreviewCardState extends State<TicketPreviewCard> {
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
      margin: EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: (){
          widget.function();
        },
        child: Container(
          //height: 190,
          margin: EdgeInsets.only(left: size.width*0.06, right: size.width*0.06,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.surface, width: (Theme.of(context).brightness == Brightness.light) ? 0 : 2),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onBackground.withOpacity(0.0),
                spreadRadius: 5,
                blurRadius: 6,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
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
                  child: Center(
                    child:
                    Text("${widget.ticketDetails.ticketNumber}",
                      style: Theme.of(context).textTheme.headline6!.apply(color: Colors.white),
                    ),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text("${(widget.ticketDetails.laneName)!.toUpperCase()}",
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

                      //Depature Date and Time
                      Container(
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


              ],
            ),
          ),
        ),
      ),
    );
  }
}
