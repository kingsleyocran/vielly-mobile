import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../presentation/widgets/custom_widgets/button.dart';
import '../../../../utilities/statusbar_util.dart';
import 'rate_viewmodel.dart';

class RateView extends StatefulWidget {

  @override
  _RateViewState createState() => _RateViewState();
}

class _RateViewState extends State<RateView> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<RateViewModel>.reactive(

      onModelReady: (model) => model.initialise(),

      viewModelBuilder: () => RateViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,

            WillPopScope(
              onWillPop: () async => false,
                child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body:  Container(
                  height: size.height,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SafeArea(bottom: false,child: Container(height: 62,)),

                            //Content Goes Here
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              child: Container(
                                  width: size.width,

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              //color: Colors.grey,
                                              child: Text('How likely are you to recommend this experience to your best friend?',
                                                style: Theme.of(context).textTheme.headline6,),
                                            ), //Header text
                                            SizedBox(height: 40,),

                                            Container(
                                              child: model.buildRateChips(context),
                                            ),//rate


                                            SizedBox(height: 30,),

                                            //Trip Feedback
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Container(
                                                    child: Text(
                                                      'Trip Feedback',
                                                      style:
                                                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          //height: 50,
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
                                                            //maxLength: 10,
                                                            scrollPadding: EdgeInsets.only(bottom:200),
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            minLines: 4,
                                                            textAlignVertical: TextAlignVertical.top,
                                                            style: Theme.of(context).textTheme.bodyText1,
                                                            //keyboardType: TextInputType.text,
                                                            //textCapitalization: TextCapitalization.words,
                                                            cursorColor: Theme.of(context).colorScheme.primary,
                                                            controller: model.feedbackController,
                                                            focusNode: model.myFocusNode,
                                                            onChanged: (value){

                                                              model.getFeedbackText(value);
                                                            },
                                                            //initialValue: address,

                                                            decoration: InputDecoration(
                                                              counterText: '',
                                                              hintText: "Enter Feedback",
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
                                            ),
                                          ],
                                        ),
                                      ),


                                    ],
                                  )
                              ),
                            ),
                            SafeArea(top: false,bottom: true, child: Container(height: 0,)),


                            //Button

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
                                  child: Container(
                                    height: 52,
                                    width: size.width,
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      //color: ViellyThemeColor_whiteBack,
                                    ),
                                  ),
                                ),
                              ),
                            ),//App Bar
                          ),
                        ),
                      ),//App Bar

                      Positioned(
                        bottom: 0,
                        child: SafeArea(
                          top: false,
                          child: Container(
                              width: size.width,

                              height: 70,
                              color: Theme.of(context).colorScheme.background,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                                    width: size.width,
                                    child: Container(

                                      child:(model.rate != null)
                                          ?
                                      Button(
                                        child:
                                        Row(
                                          mainAxisAlignment:  MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "DONE",
                                              style: Theme.of(context).textTheme.button,
                                            ),
                                          ],
                                        ),
                                        size: 45,
                                        color: Theme.of(context).colorScheme.primary,
                                        onPressed: () {
                                          model.rateTrip();
                                        },
                                      )
                                          :
                                      Button(
                                        child:
                                        Row(
                                          mainAxisAlignment:  MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "DONE",
                                              style: Theme.of(context).textTheme.button,
                                            ),
                                          ],
                                        ),
                                        size: 45,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),


                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),//General

                    ],
                  ),
                ),
            ),
              ),
          ),
    );
  }
}