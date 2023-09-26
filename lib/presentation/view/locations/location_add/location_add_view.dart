import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import '../../../../presentation/configurations/colors.dart';
import '../../../../data/models/address.dart';
import '../../../../presentation/widgets/custom_widgets/button.dart';
import '../../../../utilities/statusbar_util.dart';
import 'location_add_viewmodel.dart';


class AddLocationView extends StatelessWidget {

  final AddressDetails savedAddress;
  final bool isHomeTag;
  final bool isWorkTag;

  const AddLocationView({
    Key? key,
    required this.isHomeTag,
    required this.isWorkTag,
    required this.savedAddress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<AddLocationViewModel>.reactive(

      viewModelBuilder: () => AddLocationViewModel(),

      //disposeViewModel: false,
      //initialiseSpecialViewModelsOnce: true,
      //fireOnModelReadyOnce: true,

      onModelReady: (model)async{await model.initializer(address: savedAddress,isHome: isHomeTag, isWork: isWorkTag, context: context);},

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
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width *0.06),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                SafeArea(bottom: false,child: Container(height: 62,)),

                                //CONTENT GOES HERE
                                SizedBox(height: 20,),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          (model.isHome)? 'Home Location': (model.isWork)?'Work Location':'Location',
                                          style:
                                          Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                        ),
                                      ),

                                      SizedBox(height: 10,),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: RawMaterialButton(
                                              onPressed: (){
                                                model.getNavigator.back();
                                              },
                                              child: Container(
                                                height: 45,
                                                padding: EdgeInsets.only(
                                                  left: 14,
                                                  right: 14,
                                                  bottom: 0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,

                                                  borderRadius: BorderRadius.circular(15.00),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text((model.addressDetails != null)? model.addressDetails.placeName : 'Location',
                                                      style: Theme.of(context).textTheme.bodyText1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                //Entries Location
                                (model.isHome || model.isWork)
                                ? Container() :
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Name',
                                              style:
                                              Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                            ),
                                            Container(
                                                height: 20,
                                                width: 20,
                                                child:

                                                (model.isTagValid == 'true')
                                                    ?
                                                SvgPicture.asset('assets/icons/tick-mark.svg', color: ThemeColor_green,)
                                                    :
                                                (model.isTagValid == 'null')
                                                    ? Container()
                                                    : SvgPicture.asset('assets/icons/tick-cancel.svg', color: ThemeColor_red,)
                                            )
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 10,),

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 45,
                                              padding: EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                                bottom:2,
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
                                                controller: model.tagController,
                                                focusNode: model.tagFocusNode,
                                                onChanged: (value){
                                                  print('You have entered Name $value');
                                                  if (value.length > 3) {
                                                    model.setIsTagValid(true);

                                                  }else{
                                                    model.setIsTagValid(false);
                                                  }
                                                },
                                                onSubmitted: (value){
                                                  print('You have entered Name $value');
                                                  if (value.length > 3) {
                                                    model.setIsTagValid(true);

                                                  }else{
                                                    model.setIsTagValid(false);
                                                  }
                                                },
                                                //initialValue: "address",
                                                decoration: InputDecoration(
                                                  hintText: "Enter name e.g Pat's Home",
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
                            SizedBox(height: 50),
                            SafeArea(top: false,bottom: true, child: Container(height: 0,)),
                          ],
                        ),
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
                                          'Save Location',
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
                      child: SafeArea(
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
                                child: ((model.isHome || model.isWork) || (model.isTagValid=='true' && model.addressDetails!=null))
                                    ?
                                Button(
                                  child:
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "SAVE",
                                        style: Theme.of(context).textTheme.button,
                                      ),
                                    ],
                                  ),
                                  size: 45,
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () async{

                                    model.addNewLocation();

                                  },
                                )//ENABLED
                                    :
                                Button(
                                  child:
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "SAVE",
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
                    ),


                  ],
                ),
              ),
            ),
          ),
    );
  }
}