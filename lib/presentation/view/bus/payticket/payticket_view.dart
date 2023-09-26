
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import 'package:curve/presentation/configurations/textstyles.dart';
import '../../../widgets/custom_widgets/button.dart';
import 'payticket_viewmodel.dart';
import 'package:curve/utilities/statusbar_util.dart';

class PayTicketView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<PayTicketViewModel>.reactive(
      onModelReady: (model)async{await model.initialized(); },


      viewModelBuilder: () => PayTicketViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
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
                                SafeArea(bottom: false,child: Container(height: 62,)),

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
                                          height: 500,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Pay for the ticket',
                                                  style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onBackground),
                                                ),
                                              ), //Header text
                                              SizedBox(height: 40,),
                                              Container(
                                                child: Text('The amount to be paid for the ticket is',
                                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.surface),),
                                              ), //Your text
                                              SizedBox(height: 10,),
                                              Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text('GHC ',
                                                        style: Theme.of(context).textTheme.headline5!.apply(color: Theme.of(context).colorScheme.primary),),


                                                      Text( "${model.bookedBusData.charge}",
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

                      //Button
                      Positioned(
                        bottom: 0,
                        child: SafeArea(
                          top: false,
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
                                  child: (model.otpController.text.isNotEmpty)
                                      ?
                                  Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "PAY FOR TICKET",
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                      ],
                                    ),
                                    size: 45,
                                    color: Theme.of(context).colorScheme.primary,
                                    onPressed: () async{
                                      await model.submitOTP(context);
                                    },
                                  )
                                      :
                                  Button(
                                    child:
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "PAY FOR TICKET",
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
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}

