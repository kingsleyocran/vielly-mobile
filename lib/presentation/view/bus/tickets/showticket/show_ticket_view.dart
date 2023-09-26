
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../../presentation/widgets/custom_widgets/ticket_fullcard.dart';
import 'show_ticket_viewmodel.dart';
import '../../../../../data/models/ticket.dart';
import '../../../../../app/app.locator.dart';
import '../../../../../presentation/widgets/custom_widgets/button.dart';
import '../../../../../utilities/statusbar_util.dart';


class ShowTicketView extends StatefulWidget {

  final TicketDetails ticketDetails;

  const ShowTicketView({
    Key? key,
    required this.ticketDetails,

  })  : super(key: key);


  @override
  _ShowTicketViewState createState() => _ShowTicketViewState();
}

class _ShowTicketViewState extends State<ShowTicketView> {
  GlobalKey _globalKey = new GlobalKey();


  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<ShowTicketViewModel>.reactive(
      viewModelBuilder: () => ShowTicketViewModel(),

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
                              SafeArea( bottom: false,child: Container(height: 42,)),

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
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
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
                          SafeArea(
                            top: false,
                            child: Container(
                              width: size.width,

                              height: 80,
                              color: Theme.of(context).colorScheme.surface,
                              child: Center(
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
                                            "${AppLocalizations.of(context)!.done}",
                                            style: Theme.of(context).textTheme.button,
                                          ),
                                        ],
                                      ),
                                      size: 45,
                                      color: Theme.of(context).colorScheme.primary,
                                      onPressed: () async{

                                        model.getNavigator.back();
                                      },
                                    )//CREATE ENABLED

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
            ),
          ),
    );
  }
}
