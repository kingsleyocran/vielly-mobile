import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';


import '../../../../enums/enums.dart';
import '../../../../presentation/widgets/custom_widgets/button_white.dart';
import '../../../../presentation/widgets/custom_widgets/onfailed_screen.dart';
import '../../../../presentation/widgets/custom_widgets/onempty_screen.dart';
import '../../../../presentation/widgets/custom_widgets/location_tile.dart';
import '../../../../utilities/statusbar_util.dart';
import 'location_opt_viewmodel.dart';


class LocationOptionView extends StatelessWidget {
  const LocationOptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<LocationOptionViewModel>.reactive(
      viewModelBuilder: () => LocationOptionViewModel(),

      disposeViewModel: false,
      //initialiseSpecialViewModelsOnce: true,
      //fireOnModelReadyOnce: true,

      onModelReady: (model) async{await model.initializer();},


      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body:
              Container(
                height: size.height,
                child: Stack(

                  children: [
                    //Content
                    (model.loadingState == LoadingState.onFailed)
                        ?
                    OnFailedScreen(
                      onRetryFunction: ()async{

                        model.fetchSavedLocationData(fromRemote: true);
                      },
                    )
                        :
                    (model.loadingState != LoadingState.empty)
                          ?
                      SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SafeArea(bottom: false,child: Container(height: 30,)),

                              //CONTENT GOES HERE
                              Container(
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return (model.loadingState == LoadingState.fetched)
                                        ?
                                    LocationTile(
                                        savedLocation: model.savedLocationList[index],
                                        onEditFunction: () {

                                          model.navigateEditLocation(model.savedLocationList[index]);
                                        })
                                        :
                                    EmptyLocationTile();
                                  },
                                  separatorBuilder: (BuildContext context, int index) => Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.06,
                                    ),
                                    child: Divider(
                                      color: Theme.of(context).colorScheme.background,
                                      height: 5,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 0,
                                    ),
                                  ),
                                  itemCount: (model.savedLocationList.length == 0) ? 3 : model.savedLocationList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                ),
                              )

                            ],
                          ),
                          SizedBox(height: 50),
                          SafeArea(top: false,bottom: true, child: Container(height: 0,)),

                        ],
                      ),
                    )
                          :
                      OnEmptyScreen(
                        titleText: 'Oops!',
                        messageText: 'There are no saved locations for now',
                        buttonText: 'ADD NEW',
                        onRetryFunction: ()async{

                          model.navigateAddLocation();
                        },
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
                              color: Theme.of(context).colorScheme.background.withOpacity(0.7),
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
                                          'Saved Locations',
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
                    ),

                    //Button
                    Positioned(
                      bottom: 0,
                      child: (model.loadingState == LoadingState.fetched)
                          ?
                      SafeArea(
                        top: false,
                        child: Container(
                          width: size.width,

                          height: 70,
                          color: Theme.of(context).colorScheme.background,
                          child: Center(
                            child: Container(
                                width: size.width * 0.88,
                                margin: EdgeInsets.only(
                                    left: size.width * 0.06,
                                    right: size.width * 0.06),
                                child: (true)
                                    ?
                                ButtonWhite(
                                  child:
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "ADD NEW",
                                        style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                  size: 45,
                                  color: Theme.of(context).colorScheme.background,
                                  onPressed: () async{

                                    model.navigateAddLocation();

                                  },
                                )//ENABLED
                                    :
                                ButtonWhite(
                                  child:
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "ADD NEW",
                                        style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                    ],
                                  ),
                                  size: 45,
                                  color: Theme.of(context).colorScheme.surface,
                                )//DISABLED BUTTON
                            ),
                          ),
                        ),
                      ) : Container()
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}