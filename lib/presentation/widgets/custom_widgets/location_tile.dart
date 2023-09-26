import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

import '../../../data/models/savedlocations.dart';


class LocationTile extends StatelessWidget {
  final Function onEditFunction;
  final SavedLocationModel savedLocation;


  LocationTile(
      {required this.onEditFunction,
        required this.savedLocation}
      );


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return RawMaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        onEditFunction();
      },
      child: Container(
        height: 60,
        width: size.width,
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.symmetric(horizontal: size.width*0.06),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (savedLocation.tag == '####HOME')
                ?
            SvgPicture.asset('assets/icons/homeicon.svg' , color: Theme.of(context).colorScheme.primary,)
                :
            (savedLocation.tag == '####WORK')
                ?
            SvgPicture.asset('assets/icons/workicon.svg' , color: Theme.of(context).colorScheme.primary,)
                :
            SvgPicture.asset('assets/icons/placeicon.svg' , color: Theme.of(context).colorScheme.primary,),
            SizedBox(width: 15),
            Expanded(
              child: (savedLocation.tag == '####HOME')
                  ?
              Row(
                children: [
                  Text(
                    'Home',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
                  :
              (savedLocation.tag == '####WORK')
                  ?
              Row(
                children: [
                  Text(
                    'Work',
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
                  :
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          '${savedLocation.tag}',
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${savedLocation.name}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText2!.apply(
                                color: Theme.of(context).colorScheme.onSurface
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyLocationTile extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: 60,
      width: size.width,
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.symmetric(horizontal: size.width*0.06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          SizedBox(width: 15),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //width: size.width - 70,
                child: Container(
                    child:  Container(width: 150,
                      height: 17,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    )
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                  child: Container(width: 250,
                    height: 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}