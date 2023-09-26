import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../../../presentation/widgets/custom_widgets/button.dart';
import '../../../../utilities/statusbar_util.dart';
import 'cancelride_viewmodel.dart';

class CancelRideView extends StatefulWidget {

  @override
  _CancelRideViewState createState() => _CancelRideViewState();
}

class _CancelRideViewState extends State<CancelRideView> with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<CancelRideViewModel>.reactive(

      onModelReady: (model) => model.initialise(),

      viewModelBuilder: () => CancelRideViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,

              Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body:  Stack(
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SafeArea( bottom: false, child: Container(height: 62,)),

                          //Content Goes Here
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    child: Text(
                                      'To cancel your ride, please select a reason below',
                                      style:
                                      Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  SizedBox(height: 10,),

                                  //Reasons
                                  Container(
                                    width: size.width,
                                    //height: 200.0,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Theme.of(context).colorScheme.surface,

                                    ),

                                    child: Column(
                                      children: [
                                        model.reasonTile(context, 'Driver is too far off my route'),
                                        model.reasonTile(context, "My fellow rider can't make it"),
                                        model.reasonTile(context, "I expected a different pickup"),
                                        model.reasonTile(context, "My plans have changed"),
                                        model.reasonTile(context, "I need to go to work early"),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20,),

                                  //Other
                                  Container(child: (model.otherIsClicked == false)
                                      ?
                                  Container(
                                    width: size.width,
                                    //height: 200.0,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Theme.of(context).colorScheme.surface,

                                    ),

                                    child: Column(
                                      children: [
                                        RawMaterialButton(
                                          onPressed: (){

                                            model.setIsClicked(true);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            height: 55,
                                            //width: size.width * 0.88,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(

                                                    'Other',
                                                    style: Theme.of(context).textTheme.bodyText1,
                                                  ),
                                                ),
                                                SvgPicture.asset('assets/icons/arrowforward.svg'),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                      :
                                  Container()
                                  ),


                                  Container( child: (model.otherIsClicked == true)
                                      ?
                                  Container(
                                    child: Column(
                                      children: [

                                        Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              SizedBox(height: 20,),

                                              //Text Field
                                              Container(
                                                child: Text(
                                                  'Other Reason',
                                                  style:
                                                  Theme.of(context).textTheme.bodyText1,
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
                                                        scrollPadding: EdgeInsets.only(bottom:250),
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,
                                                        minLines: 5,
                                                        textAlignVertical: TextAlignVertical.top,
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                        //keyboardType: TextInputType.text,
                                                        textCapitalization: TextCapitalization.words,
                                                        cursorColor: Theme.of(context).colorScheme.primary,
                                                        controller: model.reasonController,
                                                        focusNode: model.reasonFocusNode,
                                                        onChanged: (value){
                                                          print(value);
                                                          model.setReasonText(value);
                                                        },

                                                        decoration: InputDecoration(
                                                          counterText: '',
                                                          hintText: "Enter Reason",
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

                                              SizedBox(height: 20,),

                                              //Button
                                              Container(
                                                  width: size.width,
                                                  height: 70,
                                                  color: Theme.of(context).colorScheme.background,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width: size.width,
                                                        child: Container(

                                                          child:(model.reason != '')
                                                              ?
                                                          Button(
                                                            child:
                                                            Row(
                                                              mainAxisAlignment:  MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "CANCEL RIDE",
                                                                  style: Theme.of(context).textTheme.button,
                                                                ),
                                                              ],
                                                            ),
                                                            size: 45,
                                                            color: Theme.of(context).colorScheme.primary,
                                                            onPressed: () {
                                                              model.cancelRide();
                                                            },
                                                          )
                                                              :
                                                          Button(
                                                            child:
                                                            Row(
                                                              mainAxisAlignment:  MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "CANCEL RIDE",
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
                                            ],
                                          ),
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
                          ),//General
                          SizedBox(height: 20,),
                          SafeArea(top: false,bottom: true, child: Container(height: 0,)),


                        ],
                      ),
                    ),


                    //Blur App Bar
                    Container(
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
                                          Navigator.pop(context);
                                        },
                                        shape: CircleBorder(),
                                        child: SvgPicture.asset(
                                            'assets/icons/icon-close-back-black.svg',
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        padding: EdgeInsets.all(2.0),

                                        elevation: 0,
                                      ),
                                    ),
                                    Container(
                                      //margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Cancel Ride',
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
                    ),//App Bar
                  ],
                ),
              ),
          ),
    );
  }
}