import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

import 'button_white.dart';


class OnEmptyScreen extends StatelessWidget {
  final Function onRetryFunction;
  final String titleText;
  final String messageText;
  final String buttonText;

  OnEmptyScreen({
    required this.onRetryFunction,
    required this.titleText,
    required this.messageText,
    required this.buttonText
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child:  Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
          //width: 80,
          padding: EdgeInsets.all(20),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$titleText",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "$messageText",
                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: ButtonWhite(
                    child:
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Text(
                          "$buttonText",
                          style: Theme.of(context).textTheme.button!.apply(color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    size: 45,
                    color: Theme.of(context).colorScheme.background,
                    onPressed: () async{

                      onRetryFunction();
                    },
                  ),
                )
                //CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(XDColor_blue),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
