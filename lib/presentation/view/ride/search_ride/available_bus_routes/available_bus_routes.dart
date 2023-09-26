

import 'dart:ui';

import 'package:curve/presentation/widgets/custom_widgets/available_route_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:curve/enums/enums.dart';
import 'available_bus_routes_viewmodel.dart';
import 'package:curve/data/models/ticket.dart';
import 'package:curve/app/app.locator.dart';
import 'package:curve/utilities/statusbar_util.dart';
import 'package:curve/presentation/widgets/custom_widgets/ticket_card.dart';


class AvailableBusRoutesView extends StatefulWidget {

  final TicketDetails? ticketDetails;

  const AvailableBusRoutesView({
    Key? key,
    this.ticketDetails,

  })  : super(key: key);


  @override
  _AvailableBusRoutesViewState createState() => _AvailableBusRoutesViewState();
}

class _AvailableBusRoutesViewState extends State<AvailableBusRoutesView> {
  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<AvailableBusRoutesViewModel>.reactive(
      viewModelBuilder: () => AvailableBusRoutesViewModel(),
      onModelReady: (model){model.initialized();},

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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SafeArea(
                          bottom: false,
                            child:
                        Container(height: 30,)
                        ),

                        //CONTENT GOES HERE
                        SizedBox(height: 10,),
                        Expanded(
                          child: (model.loadingState == LoadingState.onFailed)
                              ?
                          Container()
                              :
                          SmartRefresher(
                            physics: BouncingScrollPhysics(),
                            enablePullDown: true,
                            enablePullUp: false,
                            header: 	WaterDropHeader(
                              waterDropColor: Theme.of(context).colorScheme.primary,
                            ),
                            /*
                          footer: CustomFooter(
                          builder: (BuildContext context,LoadStatus mode){
                            Widget body ;
                            if(mode==LoadStatus.idle){
                              body =  Text("pull up load");
                            }
                            else if(mode==LoadStatus.loading){
                              body =  CupertinoActivityIndicator();
                            }
                            else if(mode == LoadStatus.failed){
                              body = Text("Load Failed!Click retry!");
                            }
                            else if(mode == LoadStatus.canLoading){
                              body = Text("release to load more");
                            }
                            else{
                              body = Text("No more Data");
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child:body),
                            );
                          },
                          ),
                                                     */
                            controller: model.refreshController,
                            onRefresh: model.onRefresh,
                            onLoading: model.onLoading,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  ListView.separated(
                                    key: PageStorageKey('storage-key'),
                                    //physics: ClampingScrollPhysics(),
                                    physics: NeverScrollableScrollPhysics(),
                                    separatorBuilder: (BuildContext context, int index) =>
                                        Container(

                                        ),
                                    itemCount: (model.loadingState == LoadingState.loading) ? 2 : model.busScheduleList.length,
                                    shrinkWrap: true,

                                    itemBuilder: (context, index) {
                                      return
                                        (model.loadingState == LoadingState.loading)
                                            ?
                                        AvailableRouteEmptyCard()
                                            :
                                        AvailableRouteCard(
                                            busSchedule: model.busScheduleList[index],

                                            function: () {
                                              model.navigateToBusDetailsBusSelect(busSchedule: model.busScheduleList[index]);
                                            }
                                        );

                                    },

                                  ),
                                  SafeArea(top: false, child: Container(),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                          '${AppLocalizations.of(context)!.availableRoutes}',
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



                  ],
                ),
              ),
            ),
          ),
    );
  }
}
