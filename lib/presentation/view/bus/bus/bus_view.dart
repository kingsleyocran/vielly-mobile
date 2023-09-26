
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';


import 'package:curve/app/app.router.dart';
import 'package:curve/enums/enums.dart';
import 'package:curve/presentation/widgets/custom_widgets/ticket_preview_card.dart';
import 'package:curve/presentation/widgets/custom_widgets/onfailed_screen.dart';
import 'package:curve/app/app.locator.dart';
import 'bus_viewmodel.dart';
import 'package:curve/utilities/statusbar_util.dart';
import '../../../widgets/custom_widgets/busschedule_cards.dart';


class BusView extends StatelessWidget {
  final ThemeService _themeService = locator<ThemeService>();
  ThemeService get getTheme => _themeService;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<BusViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,

      //On Ready model once
      //fireOnModelReadyOnce: true,

      onModelReady: (model)async{await model.initialized();},

      viewModelBuilder: () => locator<BusViewModel>(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Stack(
                children: [

                  SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Need a Bus
                        Container(
                          width: size.width,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                    left: size.width * 0.06,
                                    right: size.width * 0.06,
                                    top: 20,
                                    bottom: 20,
                                  ),
                                  child:
                                  InkWell(
                                    onTap: () async{
                                      //
                                      //
                                      model.navigateToBusDetails();

                                      //model.initialized();
                                    },

                                    child: Container(
                                      height: 45.00,
                                      width: size.width*0.88,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 10,
                                              right: 2,
                                              top: 13,
                                              bottom: 13,
                                            ),
                                            child: SvgPicture.asset(
                                                'assets/icons/search.svg'),
                                          ),
                                          Container(
                                            child: Text(
                                              'Need a Bus?',
                                              style:
                                              Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                        //Ticket Preview

                        Container(
                          child: (model.ticketDetailsList == null)
                              ?
                            Container()
                              :
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: size.width * 0.06,
                                      right: size.width * 0.06),
                                  child: Text(
                                    'Recent order',
                                    style:
                                    Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ),

                                SizedBox(height: 10,),
                                TicketPreviewCard(
                                  ticketDetails: model.ticketDetailsList[0],//[model.ticketDetailsList.length - 1],
                                  function: (){
                                    model.navigateToTicket(model.ticketDetailsList[model.ticketDetailsList.length - 1]);
                                    },
                                ),

                                //ALL TICKET BUTTON
                                Container(
                                  margin: EdgeInsets.only(
                                      left: size.width * 0.06,
                                      right: size.width * 0.06),
                                  width: size.width,

                                  child: TextButton(
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.1)),

                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
                                    onPressed: (){

                                      model.navigateToAllTickets();

                                    },
                                    child: Text(
                                      'SEE ALL TICKETS',
                                      style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),


                        //BUS SCHEDULE AREA
                        Expanded(
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              color:
                              (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onSurface ,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),

                            child:
                            (model.loadingState == LoadingState.onFailed)
                                ?
                            OnFailedScreen(
                              onRetryFunction: ()async{
                                model.getBusSchedules();
                              },
                            )
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
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
                                            BusScheduleEmptyCard()
                                                :
                                            BusScheduleCard(
                                                busSchedule: model.busScheduleList[index],

                                                function: () {
                                                  model.getNavigator.navigateTo(Routes.busTripDetailsView,
                                                      arguments: BusTripDetailsViewArguments(
                                                        busSchedule: model.busScheduleList[index],
                                                      ));
                                                }
                                            );

                                        },

                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Tranparency at top
                ],
              ),
            ),
          ),
    );
  }
}


