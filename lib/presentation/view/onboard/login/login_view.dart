
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../presentation/widgets/custom_widgets/button.dart';
import 'login_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';


class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();



  //String initialCountry = 'GH';


  //PhoneNumber number(context){
  //  return PhoneNumber(isoCode: 'GH');
  //}

  PhoneNumber number(context){
    return PhoneNumber(isoCode: (Localizations.localeOf(context).languageCode != "fr" ? 'GH' : 'CI'));
  }

  String? phoneNo;

  bool isValid = false;

  Future<Null> validate(StateSetter updateState) async {
    if (formKey.currentState!.validate()) {
      updateState(() {
        isValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<LoginViewModel>.reactive(
    viewModelBuilder: () => LoginViewModel(),
    builder: (context, model, child) =>
        StatusBarUtil.setStatusBarColorUtil(context,
          Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Form(
              //key: formKey,
              child: SafeArea(
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
                                    Flexible(
                                      child: Text(
                                        AppLocalizations.of(context)!.whatsYourNumber,
                                        style: Theme.of(context).textTheme.headline5,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Flexible(
                                        child: Text(
                                          AppLocalizations.of(context)!.wellTextCode,
                                          style: Theme.of(context).textTheme.subtitle1,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ), //TextHEADER

                          Container(
                            margin: EdgeInsets.only(
                                left: size.width * 0.06,
                                right: size.width * 0.06,
                                top: 10),
                            padding: EdgeInsets.only(left: 15),
                            height: 55,
                            width: size.width * 0.88,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(15.00),
                            ),
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                print(number.phoneNumber);
                                phoneNo = number.phoneNumber;
                              },
                              onInputValidated: (bool value) {
                                print(value);

                                setState(() {
                                  isValid = value;
                                });
                              },

                              textStyle: Theme.of(context).textTheme.bodyText1,
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                showFlags:  true,
                                useEmoji:  false,
                                setSelectorButtonAsPrefixIcon: false,

                                //todo : HERE
                                //backgroundColor: Theme.of(context).colorScheme.background,
                              ),
                              ignoreBlank: true,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: Theme.of(context).textTheme.bodyText1,

                              //initialValue: number(context),

                              countries:  ['GH', 'CI', 'NG'],

                              textFieldController: controller,
                              inputBorder: InputBorder.none,
                              autoFocus: true,
                              inputDecoration: InputDecoration(
                                hintStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                hintText: AppLocalizations.of(context)!.enterPhoneNumber,
                                border: InputBorder.none,
                              ),
                              searchBoxDecoration: InputDecoration(
                                labelStyle: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.onSurface),
                                hintText: AppLocalizations.of(context)!.searchByCountry,
                                hintStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                border: InputBorder.none,
                              ),
                            ),
                          ), //TextNumber

                          Container(
                            margin: EdgeInsets.only(top: 20, left: size.width * 0.06,
                              right: size.width * 0.06,),
                            child:
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context).textTheme.subtitle1!.apply(color: Theme.of(context).colorScheme.primary),
                                ),
                                onPressed: () {

                                },
                                child:  Text(
                                    AppLocalizations.of(context)!.changedNumber,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ), //Find your account
                        ],
                      ),

                      Container(
                        width: size.width,
                        margin: EdgeInsets.only(bottom: size.width * 0.06),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: size.width * 0.06),
                              height: 45,
                              child:
                              (isValid)
                                  ?
                              Button(
                                child:
                                Center(
                                  child: Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/icons/icon-arrow.svg'),
                                    ],
                                  ),
                                ),
                                size: 45,
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: () async{

                                  if (isValid) {
                                    model.showLoadingDialog(AppLocalizations.of(context)!.loading, false);

                                    bool internet = await model.internetCheckWithLoading();
                                    if(internet == false){
                                      return;
                                    }else{

                                      model.setPhoneNumber(phoneNo!);

                                      model.signInWithPhone(context);
                                    }
                                  } else {
                                    model.showSnackBarRedAlert(AppLocalizations.of(context)!.invalidPhoneNumber);
                                  }
                                },
                              )
                                  :
                              Button(
                                child:
                                Center(
                                  child: Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/icons/icon-arrow.svg'),
                                    ],
                                  ),
                                ),
                                size: 45,
                                color: Theme.of(context).colorScheme.onSurface,
                                onPressed: () {

                                },
                              )
                            ) //Round Button
                          ],
                        ),
                      ), //Button Action
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
