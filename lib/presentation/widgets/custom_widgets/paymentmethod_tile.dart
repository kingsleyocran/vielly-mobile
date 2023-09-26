import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import 'dart:ui';


import '../../../data/models/paymentmethods.dart';


class PaymentMethodTile extends StatelessWidget {
  final PaymentMethods paymentDefault;

  PaymentMethodTile({
    required this.paymentDefault
  });


  String _setImage(String provider) {
    String? _providerLogo;

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


  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).colorScheme.background,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //is_Primary Indicator
          Container(
            child:
            Text(paymentDefault.provider!.toUpperCase(),
              style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),),
          ),

          //Logo and EDIT BUTTON
          Container(
            //color: Colors.red,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                paymentDefault.type != null || paymentDefault.type == 'cash' ?
                Container(
                  //color: Colors.green,
                  height: 45,
                  width: 70,
                  child: Image.asset(_setImage((paymentDefault.provider).toString())),
                )
                    :
                Container(
                  //color: Colors.green,
                  height: 45,
                  width: 70,
                  child: Image.asset("assets/images/vielly_cash.png"),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}