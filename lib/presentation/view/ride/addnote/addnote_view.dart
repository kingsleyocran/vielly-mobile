import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../../../presentation/widgets/custom_widgets/button.dart';
import '../../../../utilities/statusbar_util.dart';
import 'addnote_viewmodel.dart';

class AddNoteView extends StatefulWidget {

  @override
  _AddNoteViewState createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<AddNoteViewModel>.reactive(

      onModelReady: (model) => model.initialise(),

      viewModelBuilder: () => AddNoteViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
              Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body:  SafeArea(
                    child:
                    Container(
                        width: size.width,
                        height: size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  //App bar
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
                                            child: Container(
                                              height: 52,
                                              width: size.width,
                                              margin: EdgeInsets.only(top: 10),
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
                                                    margin: EdgeInsets.only(left: 5),
                                                    child: Text(
                                                      'Add Note for driver',
                                                      style: Theme.of(context).textTheme.headline6,
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



                                  //Content Goes Here
                                  SizedBox(height: 20,),

                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Container(
                                          child: Text(
                                            'Pickup note',
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
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: null,
                                                  textAlignVertical: TextAlignVertical.top,
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                  //keyboardType: TextInputType.text,
                                                  //textCapitalization: TextCapitalization.words,
                                                  cursorColor: Theme.of(context).colorScheme.primary,
                                                  controller: model.noteController,
                                                  focusNode: model.myFocusNode,
                                                  //initialValue: address,

                                                  decoration: InputDecoration(
                                                    counterText: '',
                                                    hintText: "Enter Note",
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
                                  ), //Text Field

                                  SizedBox(height: 20,),

                                  Container(
                                      child: (model.noteController.text == '' )
                                          ?
                                      Container(
                                        width: size.width,
                                        margin: EdgeInsets.only(
                                          left: size.width * 0.06,
                                          right: size.width * 0.06,
                                          //top: 5,
                                          bottom: 10,
                                        ),
                                        child: Wrap(
                                          spacing: 8.0, // gap between adjacent chips
                                          runSpacing: 10, // gap between lines
                                          children: <Widget>[...model.generateTags(context)],
                                        ),
                                      )
                                          :
                                      Container()
                                  ), //Note Chips
                                ],
                              ),
                            ),

                            //Button
                            Container(
                                width: size.width,
                                height: 70,
                                color: Theme.of(context).colorScheme.background,
                                margin: EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: size.width,
                                      child: Container(

                                        margin: EdgeInsets.only(
                                            left: size.width * 0.06,
                                            right: size.width * 0.06),
                                        child:(model.noteController.text != '' )
                                            ?
                                        Button(
                                          child:
                                          Row(
                                            mainAxisAlignment:  MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "ADD NOTE",
                                                style: Theme.of(context).textTheme.button,
                                              ),
                                            ],
                                          ),
                                          size: 50,
                                          color: Theme.of(context).colorScheme.primary,
                                          onPressed: () {
                                            //print('Run AppPayment' + ProviderNoController.text);
                                            model.addNote();
                                          },
                                        )
                                            :
                                        Button(
                                          child:
                                          Row(
                                            mainAxisAlignment:  MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "ADD NOTE",
                                                style: Theme.of(context).textTheme.button,
                                              ),
                                            ],
                                          ),
                                          size: 50,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),


                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        )
                    ),
                  )
              )
          ),
    );
  }
}