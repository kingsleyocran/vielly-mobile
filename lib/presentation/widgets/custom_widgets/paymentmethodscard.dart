import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app/app.locator.dart';
import '../../../data/models/paymentmethods.dart';




class PaymentMethodCard extends StatefulWidget {
  final PaymentMethods paymentMethods;
  final Function setIsPrimary;
  final Function editPayment;

  PaymentMethodCard({
    required this.paymentMethods,
    required this.setIsPrimary,
    required this.editPayment
  });

  @override
  _PaymentMethodCardState createState() => _PaymentMethodCardState();
}
class _PaymentMethodCardState extends State<PaymentMethodCard> {
  final ThemeService _themeService = locator<ThemeService>();

  ThemeService get getTheme => _themeService;

  String? _providerLogo;

  String _setImage(String provider) {
    if(provider == "mtn") {
      _providerLogo = "assets/images/vielly_mtn.png";
    } else if(provider == "vodafone") {
      _providerLogo = "assets/images/vielly_vodafone.png";
    }else if(provider == "airteltigo") {
      _providerLogo = "assets/images/vielly_at.png";
    }else if(provider == "CASH") {
      _providerLogo = "assets/images/vielly_cash.png";
    }

    //print("_providerLogo: $_backgroundImage");
    return _providerLogo!; // here it returns your _backgroundImage value
  }

  String setIsPrimary(bool provider) {
    if(provider == false) {
      _providerLogo = "assets/icons/is_primary_false.svg";
    } else if(provider == true ){
      _providerLogo = "assets/icons/is_primary_true.svg";
    }

    //print("_providerLogo: $_backgroundImage");
    return _providerLogo!; // here it returns your _backgroundImage value
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).colorScheme.surface,

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 35,
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  onPressed: () async{
                    //await setPaymentIsPrimary(context);

                    widget.setIsPrimary();
                  },
                  child: Container(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          //color: Colors.grey,
                          height: 35,
                          width: 35,
                          child: (widget.paymentMethods.isPrimary!)
                              ?
                          SvgPicture.asset('assets/icons/is_primary_true.svg', )
                            :
                          SvgPicture.asset('assets/icons/is_primary_false.svg', color: Theme.of(context).colorScheme.onSurface,),

                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),//is_Primary Indicator

          //Payment Type
          Container(
            height: 65,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: widget.paymentMethods.type == 'cash'
                        ?
                    Text('CASH',
                      style: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                          ?
                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError)
                          :
                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError),
                        )
                        :
                    Text(widget.paymentMethods.provider!.toUpperCase(),
                      style: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                          ?
                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError)
                          :
                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError),),
                  ),


                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: widget.paymentMethods.phone == null || widget.paymentMethods.type == 'cash'
                        ?
                    null
                        :
                    Text(
                      (widget.paymentMethods.phone).toString(),
                      style: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                          ?
                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError)
                          :
                      Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onError),
                    ),
                  ),

                ],
              ),
            ),
          ),

          //Logo and EDIT BUTTON
          Container(
            //color: Colors.red,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.paymentMethods.provider != null || widget.paymentMethods.type == 'cash' ?
                Container(
                  //color: Colors.green,
                  height: 45,
                  width: 70,
                  child: Image.asset(_setImage((widget.paymentMethods.provider).toString())),
                )
                    :
                Container(
                  //color: Colors.green,
                  height: 45,
                  width: 70,
                  child: Image.asset("assets/images/vielly_cash.png"),
                ),
                //Method Image Logo

                Container(
                  child: Container(
                    child: widget.paymentMethods.type != 'cash'
                        ?
                    Container(
                      height: 35,
                      width: 55,
                      //padding: EdgeInsets.symmetric(horizontal: 5),
                      child: RawMaterialButton(
                        shape: StadiumBorder(),
                        padding: const EdgeInsets.only(right: 0),
                        onPressed: () {

                          widget.editPayment();
                        },
                        child: Container(
                          height: 35,
                          width: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          child: Center(
                            child: Text(
                              "${AppLocalizations.of(context)!.edit}",
                              style: (getThemeManager(context).selectedThemeMode == ThemeMode.dark)
                                  ?
                              Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.background)
                                  :
                              Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.background),
                            ),
                          ),
                        ),
                      ),
                    )//EDIT Button
                        :
                    Container(),
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




class PaymentMethodCardEmpty extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).colorScheme.surface,

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 35,
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  onPressed: () async{
                    //await setPaymentIsPrimary(context);

                  },
                  child: Container(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          //color: Colors.grey,
                          height: 35,
                          width: 35,
                          child: Image.asset('assets/images/is_primary_false.png'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),//is_Primary Indicator

          //Payment Type
          Container(
            height: 65,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //PROVIDER
                  Container(
                    height: 17,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),


                  SizedBox(
                    height: 7,
                  ),

                  //Phone
                  Container(
                    height: 17,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Logo and EDIT BUTTON
          Container(
            //color: Colors.red,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  child: Container(
                    child:
                    Container(
                      height: 35,
                      width: 55,
                      child: RawMaterialButton(
                        shape: StadiumBorder(),
                        padding: const EdgeInsets.only(right: 0),
                        onPressed: () {
                        },
                        child: Container(
                          height: 35,
                          width: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Theme.of(context).colorScheme.background,
                          ),

                        ),
                      ),
                    )//EDIT Button

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