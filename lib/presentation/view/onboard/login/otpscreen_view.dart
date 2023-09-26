
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../presentation/widgets/custom_widgets/button.dart';
import 'login_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';


class OTPScreenView extends StatefulWidget {
  final String mobileNumber;

  const OTPScreenView({
    Key? key,
    required this.mobileNumber,
  })  : assert(mobileNumber != null),
        super(key: key);

  //final FocusNode _pinPutFocusNode = FocusNode();
  @override
  _OTPScreenViewState createState() => _OTPScreenViewState();
}

class _OTPScreenViewState extends State<OTPScreenView> {
  final TextEditingController _pinEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final code = ModalRoute.of(context).settings.arguments as String;

    //_pinEditingController.text = code;

    Size size = MediaQuery.of(context).size;


    //var routeData = RouteData.of(context);
   //String mobilePhone1 = routeData.pathParams['id'].value;

    // .value will return the raw string value
    //var userId = routeData.pathParams['id'].value;
    //var queryParams = routeData.queryParams;



    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {

        model.setTimer();

        return StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SafeArea(
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            height: 50,
                            width: size.width,
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                        'assets/icons/icon-arrow-back-black.svg',
                                      color: Theme.of(context).colorScheme.onSurface,),
                                    padding: EdgeInsets.all(2.0),
                                    //fillColor: ViellyThemeColor_whiteBack,
                                    elevation: 0,
                                  ),
                                ),
                              ],
                            ),
                          ), //TopBar

                          Container(
                            margin: EdgeInsets.only(
                              left: size.width * 0.06,
                              right: size.width * 0.06,
                              bottom: 15,
                              top: 20,
                            ),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.verifyYourNumber,
                                      style: Theme.of(context).textTheme.headline5,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.enterTheCodeSent} ${widget.mobileNumber}",
                                      style: Theme.of(context).textTheme.subtitle1,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ), //TextHEADER

                          Container(
                            height: 58,
                            margin: EdgeInsets.only(
                              top: 10,
                            ),
                            width: size.width * 0.88 + 20,
                            child:
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: PinInputTextField(
                                pinLength: 6,
                                decoration:BoxLooseDecoration(
                                  strokeColorBuilder: PinListenColorBuilder(Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surface),
                                  bgColorBuilder: PinListenColorBuilder(Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surface),
                                  /*
                                  obscureStyle: ObscureStyle(
                                    isTextObscure: _obscureEnable,
                                    obscureText: '☺️',
                                  ),

                                   */
                                  radius: Radius.circular(13),
                                  strokeWidth: 1,
                                  textStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                  hintTextStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                ),
                                /*
                                BoxLooseDecoration (
                                    textStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                    hintTextStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                    radius: Radius.circular(13),
                                    enteredColor: Theme.of(context).colorScheme.surface,
                                    solidColor: Theme.of(context).colorScheme.surface,
                                    strokeColor: Theme.of(context).colorScheme.surface,
                                    strokeWidth: 0,

                                ),

                                 */
                                controller: _pinEditingController,
                                autoFocus: true,
                                textInputAction: TextInputAction.done,
                                onSubmit: (pin) {
                                  if (pin.length == 6) {
                                    print('>>>>>>>>>>>>>>>>> onSubmit');

                                    model.verifyCode(context, pin);

                                  } else {
                                    _pinEditingController.clear();
                                    model.showSnackBarRedAlert(AppLocalizations.of(context)!.pleaseEnterValid);
                                  }
                                },
                              ),
                            ),
                          ), // Textfield


                          Container(
                            margin: EdgeInsets.only(
                                top: 10,
                                right: size.width * 0.06,
                                left: size.width * 0.06),
                            width: size.width,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      AppLocalizations.of(context)!.didntReceiveSMS,
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                  Container(
                                    //width: 65,
                                    //height: 20,
                                    child:
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.primary),
                                      ),
                                      onPressed: (model.allowSendNew)
                                          ?
                                          () {model.resendCode(context);}
                                          :
                                          null,
                                      child: Text(AppLocalizations.of(context)!.getNew),

                                    ),
                                  ),
                                ]),
                          ), //Text row
                        ],
                      ),

                      Container(
                        width: size.width * 0.88,
                        margin: EdgeInsets.only(
                            left: size.width * 0.06,
                            right: size.width * 0.06,
                            bottom: size.width * 0.06),
                        child:
                        Button(
                          child:
                          Row(
                            mainAxisAlignment:  MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.verify.toUpperCase(),
                                style: Theme.of(context).textTheme.button,
                              ),
                            ],
                          ),
                          size: 45,
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () async{

                            print('You entered => ${_pinEditingController.text.trim()}');
                            if (_pinEditingController.text.isNotEmpty &&
                                _pinEditingController.text.length == 6)
                              model.verifyCode(
                                  context, _pinEditingController.text.trim());
                            else{
                              _pinEditingController.clear();
                              model.showSnackBarRedAlert(AppLocalizations.of(context)!.pleaseEnterValid);
                            }
                          },
                        ),

                      ), //Button Action
                    ],
                  ),
                ),
              ),
            ),
          );
      },
    );
  }
}

