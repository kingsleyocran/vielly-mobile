import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';

import 'package:curve/enums/enums.dart';
import 'package:curve/presentation/widgets/custom_widgets/ridehistory_card.dart';
import 'package:curve/utilities/statusbar_util.dart';
import 'ride_history_viewmodel.dart';


class RideHistoryView extends StatelessWidget {
  const RideHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<RideHistoryViewModel>.reactive(
      viewModelBuilder: () => RideHistoryViewModel(),

      //disposeViewModel: false,
      //initialiseSpecialViewModelsOnce: true,
      //fireOnModelReadyOnce: true,

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
                        Container(height: 20,)
                        ),

                        //CONTENT GOES HERE
                        SizedBox(height: 25,),
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
                                    itemCount: (model.loadingState == LoadingState.loading) ? 2 : model.rideHistoryList.length,
                                    shrinkWrap: true,

                                    itemBuilder: (context, index) {
                                      return
                                        (model.loadingState == LoadingState.loading)
                                            ?
                                        RideHistoryEmptyCard()
                                            :
                                        RideHistoryCard(
                                            rideHistory: model.rideHistoryList[index],

                                            function: () {
                                              model.navigateToTicket(model.rideHistoryList[index]);
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
                        SafeArea(top: false,bottom: true, child: Container(height: 0,)),

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
                                          'Ride History',
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