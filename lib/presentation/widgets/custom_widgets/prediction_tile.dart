import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../data/data_sources/local/sharedpreference.dart';
import '../../../data/models/address.dart';
import '../../../data/models/location_prediction.dart';


class PredictionTile extends StatelessWidget {
  final Function? onDestinationSelected;
  final Function? onPickupSelected;
  final Function? onSavedLocationSelect;
  final Function? onEditLocation;
  final Prediction? prediction;
  final bool? isPickup;
  final bool? isSaveLocation;
  final bool? isEditLocation;

  PredictionTile(
      { this.isPickup,
         this.prediction,
         this.isSaveLocation,
        this.onClose,
        this.onPickupSelected,
        this.onDestinationSelected,
        this.onSavedLocationSelect,
        this.onEditLocation,
        this.isEditLocation,
      });

  final void Function({String returnValue})? onClose;

  final DialogService _dialogService = locator<DialogService>();
  DialogService get getDialogService => _dialogService;

  final SharedPrefManager _sharedPrefManager = locator<SharedPrefManager>();
  SharedPrefManager get getSharedPrefManager => _sharedPrefManager;

  final NavigationService _navigationService = locator<NavigationService>();
  NavigationService get getNavigator => _navigationService;

  void getPlaceDetails(String placeID, context) async {

    print('###########PLACE ID =' + placeID);


    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=AIzaSyBRH0E02krGb4Zd2qs9jvi6dMAOEihutqs';

    var response = await getRequest(Uri.parse(url));

    if (response == 'failed') {
      return;
    }
    print(response);

    if (response['status'] == 'OK') {
      AddressDetails thisPlace = AddressDetails();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeID = placeID;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.longitude = response['result']['geometry']['location']['lng'];

      print(thisPlace.placeName);
      print("isPickup??? $isPickup");

      if (isPickup!) {

        print('This is the pickup address'+ thisPlace.placeName!);

        getSharedPrefManager.setPrefPickupAddress(thisPlace);
        onPickupSelected!(thisPlace);
      }else if(isEditLocation! && isSaveLocation!){
        //Execute the function
        onEditLocation!(thisPlace);
        print('This is the saved location address '+ thisPlace.placeName!);

      }
      else if(isSaveLocation!){
        //Execute the function
        onSavedLocationSelect!(thisPlace);

        print('This is the saved location address '+ thisPlace.placeName!);

      }
      else {

        getSharedPrefManager.setPrefDropOffAddress(thisPlace);

        getNavigator.back();
        //Execute the function
        onDestinationSelected!(thisPlace);

        print('This is the destination address '+ thisPlace.placeName!);

      }

    }
  }

  Future<dynamic> getRequest(var url) async {
    http.Response response = await http.get(url);

    try{
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      }
      else {
        return 'failed';
      }
    }catch(e){
      return 'failed';
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return RawMaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        getPlaceDetails(prediction!.placeID!, context);
        print('GET PLACE DETAILS');
      },
      child: Container(
        height: 60,
        width: size.width,
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.symmetric(horizontal: size.width*0.06),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/icons/placeicon.svg' , color: Theme.of(context).colorScheme.onSurface,),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${prediction!.mainText}',
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
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
                            '${prediction!.secondaryText??prediction!.mainText}',
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

class EmptyPredictionTile extends StatelessWidget {



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