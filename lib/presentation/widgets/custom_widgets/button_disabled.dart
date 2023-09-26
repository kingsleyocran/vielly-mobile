import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';


class ButtonDisabled extends StatefulWidget {

  final String text;

  ButtonDisabled({
    required this.text,

  });

  @override
  ButtonDisabledState createState() => ButtonDisabledState();
}

class ButtonDisabledState extends State<ButtonDisabled> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width*0.06),

    );
  }
}