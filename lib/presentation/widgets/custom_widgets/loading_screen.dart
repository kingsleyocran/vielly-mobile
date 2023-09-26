import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';



class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child:  Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width*0.06),
          height: 130,
          //width: 80,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius:  BorderRadius.circular(10),
              color:
              Theme.of(context).colorScheme.background

          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: SpinKitThreeBounce(
                      color:
                      Theme.of(context).colorScheme.onSurface
                  ),
                ),
                //CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(XDColor_blue),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
