import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../presentation/configurations/colors.dart';
import '../../presentation/widgets/custom_widgets/button.dart';
import '../../app/app.locator.dart';
/// The type of dialog to show
enum DialogType { basic, form, loading, onFailed, onConfirmRed, onDriverArrived, onNoDriver, onBusNotStarted}

final ThemeService _themeService = locator<ThemeService>();
ThemeService get getTheme => _themeService;

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.basic: (context, sheetRequest, completer) =>
        _BasicDialog(request: sheetRequest, completer: completer),
    DialogType.form:  (context, sheetRequest, completer) =>
        _FormDialog(request: sheetRequest, completer: completer),
    DialogType.loading:  (context, sheetRequest, completer) =>
        _LoadingDialog(request: sheetRequest, completer: completer),
    DialogType.onFailed:  (context, sheetRequest, completer) =>
        _OnFailedDialog(request: sheetRequest, completer: completer),
    DialogType.onConfirmRed:  (context, sheetRequest, completer) =>
        _OnConfirmRedDialog(request: sheetRequest, completer: completer),
    DialogType.onDriverArrived:  (context, sheetRequest, completer) =>
        _OnDriverArrived(request: sheetRequest, completer: completer),
    DialogType.onNoDriver:  (context, sheetRequest, completer) =>
        _OnNoDriver(request: sheetRequest, completer: completer),
    DialogType.onBusNotStarted:  (context, sheetRequest, completer) =>
        _OnBusNotStarted(request: sheetRequest, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}


/*
class BasicDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const BasicDialog({Key key, this.request, this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child:
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              request.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              request.description,
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              // Complete the dialog when you're done with it to return some data
              onTap: () => completer(DialogResponse(confirmed: true)),
              child: Container(
                child: request.showIconInMainButton
                    ? Icon(Icons.check_circle)
                    : Text(request.mainButtonTitle),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

 */

class _FormDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const _FormDialog(
      {Key? key,
        required this.request,
        required this.completer
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(), /* Build your dialog UI here */
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const _LoadingDialog({Key? key, required this.request, required this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: size.width*0.20),
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(10),
      ),
      //backgroundColor: Colors.transparent,
      child: Container(
        //margin: EdgeInsets.symmetric(horizontal: 100),
        height: 130,
        //width: 80,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.circular(10),
          color: (Theme.of(context).colorScheme.brightness == Brightness.light)
              ?
          Theme.of(context).colorScheme.background
              :
          Theme.of(context).colorScheme.surface
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: SpinKitThreeBounce(
                      color:
                      Theme.of(context).colorScheme.onError
                  ),
              ),
              //CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(XDColor_blue),),
              SizedBox(height: 5,),
              Text(
                request.title!,
                style: Theme.of(context).textTheme.headline6!.apply(
                    color:
                    Theme.of(context).colorScheme.onError
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _BasicDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const _BasicDialog({Key? key, required this.request, required this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: size.width*0.05),
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 20),
            //margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
            width: size.width*0.80,
            decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(15),
                color:
                (Theme.of(context).colorScheme.brightness == Brightness.light)
                    ?
                Theme.of(context).colorScheme.background
                    :
                Theme.of(context).colorScheme.surface

            ),
            child: Column(
              children: [
                Container(
                    child:
                    Column(
                      children: [
                        Text(
                          request.title!,
                          style: Theme.of(context).textTheme.headline6!.apply(
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onPrimary
                                  :
                              Theme.of(context).colorScheme.onError
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10,),
                        Text(
                          request.description!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2!.apply(
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSurface
                                  :
                              Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20,),
                Container(
                  //margin: EdgeInsets.symmetric(horizontal:10),
                  //width: size.width*0.65,
                  width: size.width,
                  //padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Button(
                    child:
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Text(
                          request.mainButtonTitle!,
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                    size: 45,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () async{
                      completer(DialogResponse(confirmed: true));
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: size.width,
                  height: 45,
                  child: TextButton(
                    style: ButtonStyle(
                      /*
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).colorScheme.error.withOpacity(0.1);
                              return null; // Use the component's default.
                            },
                        ),

                       */
                      overlayColor: MaterialStateProperty.all(ThemeColor_blue.withOpacity(0.1)),

                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
                    onPressed: (){
                      //completer(SheetResponse(confirmed: true));
                      completer(DialogResponse(confirmed: false));
                    },
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: Theme.of(context).textTheme.button!.apply(color: ThemeColor_blue),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnFailedDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const _OnFailedDialog({Key? key, required this.request, required this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: size.width*0.05),
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 20),
            //margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
            width: size.width*0.80,
            decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(15),
                color:
                (Theme.of(context).colorScheme.brightness == Brightness.light)
                    ?
                Theme.of(context).colorScheme.background
                    :
                Theme.of(context).colorScheme.surface

            ),
            child: Column(
              children: [
                Container(
                  child:
                  Column(
                    children: [
                      Text(
                          request.title!,
                          style: Theme.of(context).textTheme.headline6!.apply(
                                color:
                                (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                    ?
                                Theme.of(context).colorScheme.onPrimary
                                    :
                                Theme.of(context).colorScheme.onError
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        request.description!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2!.apply(
                            color:
                            (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                ?
                            Theme.of(context).colorScheme.onSurface
                                :
                            Theme.of(context).colorScheme.onBackground
                        ),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 20,),
                Container(
                  //margin: EdgeInsets.symmetric(horizontal:10),
                  //width: size.width*0.65,
                  width: size.width,
                  //padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Button(
                    child:
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Text(
                          request.mainButtonTitle!,
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                    size: 45,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () async{
                      completer(DialogResponse(confirmed: true));
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: size.width,
                  height: 45,
                  child: TextButton(
                    style: ButtonStyle(
                      /*
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).colorScheme.error.withOpacity(0.1);
                              return null; // Use the component's default.
                            },
                        ),

                       */
                      overlayColor: MaterialStateProperty.all(ThemeColor_red.withOpacity(0.1)),

                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
                      onPressed: (){
                        //completer(SheetResponse(confirmed: true));
                        completer(DialogResponse(confirmed: false));
                      },
                    child: Text(
                        request.secondaryButtonTitle!,
                        style: Theme.of(context).textTheme.button!.apply(color: ThemeColor_red),
                      ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnConfirmRedDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const _OnConfirmRedDialog({Key? key, required this.request, required this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: size.width*0.05),
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 20),
            //margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
            width: size.width*0.80,
            decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(15),
                color:
                (Theme.of(context).colorScheme.brightness == Brightness.light)
                    ?
                Theme.of(context).colorScheme.background
                    :
                Theme.of(context).colorScheme.surface

            ),
            child: Column(
              children: [
                Container(
                    child:
                    Column(
                      children: [
                        Text(
                          request.title!,
                          style: Theme.of(context).textTheme.headline6!.apply(
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onPrimary
                                  :
                              Theme.of(context).colorScheme.onError
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10,),
                        Text(
                          request.description!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2!.apply(
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onSurface
                                  :
                              Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20,),
                Container(
                  //margin: EdgeInsets.symmetric(horizontal:10),
                  //width: size.width*0.65,
                  width: size.width,
                  //padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Button(
                    child:
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Text(
                          request.mainButtonTitle!,
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                    size: 45,
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () async{
                      completer(DialogResponse(confirmed: true));
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: size.width,
                  height: 45,
                  child: TextButton(
                    style: ButtonStyle(
                      /*
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).colorScheme.error.withOpacity(0.1);
                              return null; // Use the component's default.
                            },
                        ),

                       */
                      overlayColor: MaterialStateProperty.all(ThemeColor_red.withOpacity(0.1)),

                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
                    onPressed: (){
                      //completer(SheetResponse(confirmed: true));
                      completer(DialogResponse(confirmed: false));
                    },
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: Theme.of(context).textTheme.button!.apply(color: ThemeColor_red),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnDriverArrived extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const _OnDriverArrived({Key? key, required this.request, required this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: size.width*0.05),
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 20),
            //margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
            width: size.width*0.80,
            decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(15),
                color:
                (Theme.of(context).colorScheme.brightness == Brightness.light)
                    ?
                Theme.of(context).colorScheme.background
                    :
                Theme.of(context).colorScheme.surface

            ),
            child: Column(
              children: [
                Container(
                    child:
                    Column(
                      children: [

                        Text(
                          'Your driver has arrived',
                          style: Theme.of(context).textTheme.headline6!.apply(
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onPrimary
                                  :
                              Theme.of(context).colorScheme.onError
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20,),

                        //Profile
                        Container(
                          height: 150,
                          width: 150,
                          child: Stack(
                            children: [
                              Container(
                                height: 145,
                                width: 145,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(55.0)), //add border radius here
                                    child:(request.data != null)
                                        ?
                                    Image.network(
                                      '${request.data.driverImageOriginal}'
                                    )
                                        :
                                    Image.asset(
                                        'assets/images/emptyprofile.png'
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10,),
                        //Driver details
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                (request.data != null) ? request.data.driverName : "No Driver Name",
                                style: Theme.of(context).textTheme.headline6!.apply(
                                    color: Theme.of(context).colorScheme.primary
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2,),
                              Text(
                                (request.data != null) ? "${request.data.carColor} ${request.data.carModel}" : "####",
                                style: Theme.of(context).textTheme.bodyText1!.apply(
                                    color: Theme.of(context).colorScheme.onError
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                (request.data != null) ? "Vehicle Number: ${request.data.vehicleNumber}" : "####",
                                style: Theme.of(context).textTheme.bodyText2!.apply(
                                    color: Theme.of(context).colorScheme.onSurface
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20,),
                Container(
                  //margin: EdgeInsets.symmetric(horizontal:10),
                  //width: size.width*0.65,
                  width: size.width,
                  //padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Button(
                    child:
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Text(
                          'DONE',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                    size: 45,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () async{
                      completer(DialogResponse(confirmed: true));
                    },
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnNoDriver extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const _OnNoDriver({Key? key, required this.request, required this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: size.width*0.05),
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 20),
            //margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
            width: size.width*0.80,
            decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(15),
                color:
                (Theme.of(context).colorScheme.brightness == Brightness.light)
                    ?
                Theme.of(context).colorScheme.background
                    :
                Theme.of(context).colorScheme.surface

            ),
            child: Column(
              children: [
                Container(
                    child:
                    Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: SvgPicture.asset('assets/icons/nocar1.svg', color: Theme.of(context).colorScheme.error,),),
                        SizedBox(height: 15,),
                        Text(
                          '${request.title}',
                          style: Theme.of(context).textTheme.headline6!.apply(
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onPrimary
                                  :
                              Theme.of(context).colorScheme.onError
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "${request.description}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2!.apply(
                              color:
                              Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20,),
                Container(
                  //margin: EdgeInsets.symmetric(horizontal:10),
                  //width: size.width*0.65,
                  width: size.width,
                  //padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Button(
                    child:
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Text(
                          '${request.mainButtonTitle}',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                    size: 45,
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () async{
                      completer(DialogResponse(confirmed: true));
                    },
                  ),
                ),
                /*
                SizedBox(height: 10,),
                Container(
                  width: size.width,
                  height: 45,
                  child: TextButton(
                    style: ButtonStyle(
                      /*
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).colorScheme.error.withOpacity(0.1);
                              return null; // Use the component's default.
                            },
                        ),

                       */
                      overlayColor: MaterialStateProperty.all(ThemeColor_red.withOpacity(0.1)),

                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
                    onPressed: (){
                      //completer(SheetResponse(confirmed: true));
                      completer(DialogResponse(confirmed: false));
                    },
                    child: Text(
                      request.secondaryButtonTitle,
                      style: Theme.of(context).textTheme.button.apply(color: ThemeColor_red),
                    ),
                  ),
                )

                 */
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnBusNotStarted extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const _OnBusNotStarted({Key? key, required this.request, required this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: size.width*0.05),
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 20),
            //margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
            width: size.width*0.80,
            decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(15),
                color:
                (Theme.of(context).colorScheme.brightness == Brightness.light)
                    ?
                Theme.of(context).colorScheme.background
                    :
                Theme.of(context).colorScheme.surface

            ),
            child: Column(
              children: [
                Container(
                    child:
                    Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: SvgPicture.asset('assets/icons/nocar1.svg', color: Theme.of(context).colorScheme.error,),),
                        SizedBox(height: 15,),
                        Text(
                          'Bus Trip not yet started',
                          style: Theme.of(context).textTheme.headline6!.apply(
                              color:
                              (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).colorScheme.onPrimary
                                  :
                              Theme.of(context).colorScheme.onError
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "The bus trip has not yet started",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2!.apply(
                              color:
                              Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20,),
                Container(
                  //margin: EdgeInsets.symmetric(horizontal:10),
                  //width: size.width*0.65,
                  width: size.width,
                  //padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Button(
                    child:
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Text(
                          'CANCEL',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                    size: 45,
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () async{
                      completer(DialogResponse(confirmed: true));
                    },
                  ),
                ),
                /*
                SizedBox(height: 10,),
                Container(
                  width: size.width,
                  height: 45,
                  child: TextButton(
                    style: ButtonStyle(
                      /*
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).colorScheme.error.withOpacity(0.1);
                              return null; // Use the component's default.
                            },
                        ),

                       */
                      overlayColor: MaterialStateProperty.all(ThemeColor_red.withOpacity(0.1)),

                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0))),                    ),
                    onPressed: (){
                      //completer(SheetResponse(confirmed: true));
                      completer(DialogResponse(confirmed: false));
                    },
                    child: Text(
                      request.secondaryButtonTitle,
                      style: Theme.of(context).textTheme.button.apply(color: ThemeColor_red),
                    ),
                  ),
                )

                 */
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//completer(DialogResponse(confirmed: true));

