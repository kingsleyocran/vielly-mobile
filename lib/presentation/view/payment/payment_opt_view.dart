import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../enums/enums.dart';
import '../../../presentation/widgets/custom_widgets/button_white.dart';
import '../../../presentation/widgets/custom_widgets/onfailed_screen.dart';
import '../../../presentation/widgets/custom_widgets/paymentmethodscard.dart';
import '../../../utilities/statusbar_util.dart';
import 'payment_opt_viewmodel.dart';


class PaymentOptionView extends StatefulWidget{

  const PaymentOptionView({Key? key}) : super(key: key);

  @override
  _PaymentOptionViewState createState() => _PaymentOptionViewState();
}

class _PaymentOptionViewState extends State<PaymentOptionView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<PaymentOptionViewModel>.reactive(
      viewModelBuilder: () => PaymentOptionViewModel(),

      disposeViewModel: true,
      //initialiseSpecialViewModelsOnce: true,
      //fireOnModelReadyOnce: false,
      onModelReady: (model) async{await model.initialized();},

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

                        model.initialized();
                      },
                    )
                        :
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SafeArea( bottom: false,child: Container(height: 50,)),

                          //CONTENT GOES HERE
                          //Payment cards
                          Container(
                            //color: Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: size.width*0.06),
                            child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: (model.loadingState == LoadingState.fetched) ? model.paymentMethodList.length : 4,
                                //primary: true,
                                shrinkWrap: true,

                                //addAutomaticKeepAlives: true,
                                //padding: EdgeInsets.all(0),
                                gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  childAspectRatio: (3 / 3.5),
                                ),
                                itemBuilder: (BuildContext context, int index){
                                  return (model.loadingState == LoadingState.fetched)
                                      ?
                                    PaymentMethodCard(
                                      paymentMethods: model.paymentMethodList[index],
                                      editPayment: (){model.navigateEditPayment(model.paymentMethodList[index]);},
                                      setIsPrimary: (){model.setIsPrimary(model.paymentMethodList[index]);},
                                    )
                                      :
                                      PaymentMethodCardEmpty();
                                }),
                          ),

                          SizedBox(height: 70),
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
                                          '${AppLocalizations.of(context)!.paymentOptions}',
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
                      child: (model.loadingState == LoadingState.fetched || model.loadingState == LoadingState.loading)
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
                                        "${AppLocalizations.of(context)!.addNew}",
                                        style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                  size: 45,
                                  color: Theme.of(context).colorScheme.background,
                                  onPressed: () async{

                                    model.navigateAddPayment();

                                  },
                                )//ENABLED
                                    :
                                ButtonWhite(
                                  onPressed: (){},
                                  child:
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${AppLocalizations.of(context)!.addNew}",
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
                      ) : Container(),
                    ),


                  ],
                ),
              ),
            ),
          ),
    );
  }
}