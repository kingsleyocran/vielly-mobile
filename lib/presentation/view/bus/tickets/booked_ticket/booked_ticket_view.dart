
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../../presentation/widgets/custom_widgets/ticket_fullcard.dart';
import 'booked_ticket_viewmodel.dart';
import '../../../../../data/models/ticket.dart';
import '../../../../../app/app.locator.dart';
import '../../../../../presentation/widgets/custom_widgets/button.dart';
import '../../../../../utilities/statusbar_util.dart';


class BookedTicketView extends StatefulWidget {

  final TicketDetails ticketDetails;

  const BookedTicketView({
    Key? key,
    required this.ticketDetails,

  })  : super(key: key);


  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends State<BookedTicketView> {
  GlobalKey _globalKey = new GlobalKey();


  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<BookedTicketViewModel>.reactive(
      viewModelBuilder: () => BookedTicketViewModel(),

      onModelReady: (model){model.initialized(widget.ticketDetails);},

      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              body:
              Container(
                height: size.height,
                child: Stack(

                  children: [
                    //Content
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SafeArea(
                                  bottom: false,
                                  child: Container(height: 42,
                                  )
                              ),

                              //CONTENT GOES HERE

                              //TICKET
                              RepaintBoundary(
                                key: _globalKey,
                                child: Ticket(
                                  ticketDetails: model.ticketDetails,
                                  userProfile: model.userProfile,
                                  function: (){},
                                ),
                              ),

                              SizedBox(
                                height: 5,),

                              //Download and Share buttons
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: size.width * 0.09),
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    //Download
                                    RawMaterialButton(
                                      onPressed: () async{

                                        await model.downloadTicket(globalKey: _globalKey);

                                      },
                                      child: Container(
                                        child: Row(
                                          children: [

                                            Container(
                                              height: 16,
                                              width: 16,

                                              child: SvgPicture.asset(
                                                  'assets/icons/download.svg' , color: Theme.of(context).colorScheme.onSurface),
                                            ),

                                            SizedBox(width: 5,),

                                            Text("${AppLocalizations.of(context)!.download}",
                                              style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onSurface),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),

                                    //Share
                                    RawMaterialButton(
                                      onPressed: ()async{

                                        await model.shareTicket(globalKey: _globalKey);
                                      },
                                      child: Container(
                                        child: Row(
                                          children: [

                                            Container(
                                              height: 16,
                                              width: 16,

                                              child: SvgPicture.asset(
                                                'assets/icons/share.svg' , color: Theme.of(context).colorScheme.onSurface,),
                                            ),

                                            SizedBox(width: 5,),

                                            Text("${AppLocalizations.of(context)!.share}",
                                              style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onSurface),
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
                          SizedBox(height: 50),
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
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                              child:
                              SafeArea(
                                bottom: false,
                                child:
                                Container(
                                  height: 52,
                                  width: size.width,
                                  //margin: EdgeInsets.only(top: 10),
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
                                          '${AppLocalizations.of(context)!.ticket}',
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

                    //Buttons
                    Positioned(
                      bottom: 0,
                      child: Column(
                        children: [
                          Container(
                            width: size.width,

                            height: 70,
                            color: Theme.of(context).colorScheme.surface,
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
                                          "${AppLocalizations.of(context)!.trackTrip}",
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                      ],
                                    ),
                                    size: 45,
                                    color: Theme.of(context).colorScheme.primary,
                                    onPressed: () async{
                                      await model.startBusTrip();
                                    },
                                  )//CREATE ENABLED
                                      :
                                  Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context)!.startTrip}",
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

                          //BACK BUTTON
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

                          SafeArea(top: false,bottom: true, child: Container(height: 0,)),
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
