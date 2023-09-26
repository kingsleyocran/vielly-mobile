
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../presentation/configurations/textstyles.dart';
import '../../../../presentation/widgets/custom_widgets/button.dart';
import 'pay_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';

class PayView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;


    return ViewModelBuilder<PayViewModel>.reactive(
      viewModelBuilder: () => PayViewModel(),

      onModelReady: (model)async{await model.initialized(); },

      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body:
                GestureDetector(
                  onTap: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    height: size.height,
                    child: Stack(

                      children: [
                        //Content
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  SafeArea(child: Container(height: 62,)),

                                  //CONTENT GOES HERE
                                  SizedBox(height: 10,),
                                  Container(
                                      width: size.width,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: size.width,

                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text('Pay for the trip',
                                                    style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                  ),
                                                ), //Header text
                                                SizedBox(height: 15,),
                                                Container(
                                                  child: Text('The amount to be paid for the ticket is',
                                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),),
                                                ), //Your text
                                                SizedBox(height: 30,),
                                                Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('GHC ',
                                                          style: Theme.of(context).textTheme.headline5!.apply(color: Theme.of(context).colorScheme.primary),),


                                                        Text( (model.tripDetails != null) ? "${model.tripDetails.charge}" : 'NULL',
                                                          style: ThemeText_Bold_60.apply(color: Theme.of(context).colorScheme.primary),
                                                        ),
                                                      ],
                                                    )
                                                ), //Amount

                                                Container(
                                                    child: (model.primaryPaymentMethod.provider == 'vodafone')//sharedpref.getIsPrimary() == "vodafone"
                                                        ?
                                                    Container(
                                                      width: size.width,
                                                      margin: EdgeInsets.symmetric(horizontal: size.width*0.06, vertical: 30),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              'Vodafone Payment Voucher',
                                                              style:
                                                              Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                            ),
                                                          ),
                                                          SizedBox(height: 13,),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  height: 50,
                                                                  padding: EdgeInsets.only(
                                                                    left: 14,
                                                                    right: 14,
                                                                    bottom: 0,
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    color: Theme.of(context).colorScheme.surface,
                                                                    borderRadius: BorderRadius.circular(15.00),
                                                                  ),
                                                                  child: TextField(
                                                                    scrollPadding: EdgeInsets.only(bottom:100),
                                                                    textAlignVertical: TextAlignVertical.top,
                                                                    style: Theme.of(context).textTheme.bodyText1,
                                                                    keyboardType: TextInputType.text,
                                                                    textCapitalization: TextCapitalization.words,
                                                                    cursorColor: Theme.of(context).colorScheme.primary,
                                                                    controller: model.otpController,
                                                                    //initialValue: "address",
                                                                    decoration: InputDecoration(
                                                                      hintText: "Enter your payment voucher",
                                                                      hintStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                                      border: new OutlineInputBorder(
                                                                        borderRadius:
                                                                        new BorderRadius.circular(12.0),
                                                                      ),
                                                                      focusedBorder: InputBorder.none,
                                                                      enabledBorder: InputBorder.none,
                                                                      errorBorder: InputBorder.none,
                                                                      disabledBorder: InputBorder.none,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                        :
                                                    Container()
                                                ),

                                              ],
                                            ),
                                          ),


                                        ],
                                      )
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
                                  color: Theme.of(context).colorScheme.background.withOpacity(0.7),
                                  child:
                                  SafeArea(
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

                                          ),

                                          Container(

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
                          child: Container(
                            width: size.width,

                            //Button
                            height: 70,
                            color: Theme.of(context).colorScheme.background,
                            child: Center(
                              child: Container(
                                  width: size.width * 0.88,
                                  margin: EdgeInsets.only(
                                      left: size.width * 0.06,
                                      right: size.width * 0.06),
                                  child: (model.primaryPaymentMethod.provider != 'vodafone' && model.otpController.text.isEmpty)
                                      ?
                                  Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "PAY FOR TRIP",
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                      ],
                                    ),
                                    size: 45,
                                    color: Theme.of(context).colorScheme.primary,
                                    onPressed: () async{
                                      await model.payForTrip();
                                    },
                                  )
                                      :
                                  Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "PAY FOR TRIP",
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                      ],
                                    ),
                                    size: 45,
                                    color: Theme.of(context).colorScheme.onSurface,

                                  )//DISABLED BUTTON
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

