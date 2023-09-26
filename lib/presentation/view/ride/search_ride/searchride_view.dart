
import 'package:curve/app/app.router.dart';
import 'package:curve/services/third_party_services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../app/app.locator.dart';
import '../../../../data/data_sources/local/sharedpreference.dart';
import '../../../../data/models/location_prediction.dart';
import '../../../../presentation/widgets/custom_widgets/prediction_tile.dart';
import 'searchride_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SearchRideView extends StatefulWidget {

  final Function? onDestinationSelected;

  SearchRideView({this.onDestinationSelected, Key? key}) : super(key: key);

  @override
  _SearchRideViewState createState() => _SearchRideViewState();
}

class _SearchRideViewState extends State<SearchRideView> {

  bool isPickup = false;
  bool isSavedLocation = false;

  final SharedPrefManager _sharedPrefManager = locator<SharedPrefManager>();
  SharedPrefManager get getSharedPrefManager => _sharedPrefManager;

  final LocationService _locationService = locator<LocationService>();
  LocationService get getLocationService => _locationService;

  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  late Position currentLocation;

  var destinationFocus = FocusNode();

  bool focused = false;
  String address = '';

  String state = 'idle';

  List<Prediction> destinationPredictionList = [];

  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(destinationFocus);
      focused = true;
    }
  }

  void searchPlace(String placeName) async {
    setState(() {
      state = 'loading';
    });

    if (placeName.length > 1) {

      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyBRH0E02krGb4Zd2qs9jvi6dMAOEihutqs&sessiontoken=1234567890';
      var response = await getRequest(url);

      print('#######################');
      if (response == 'failed') {
        setState(() {
          state = 'error';
        });
        return;
      }
      print(response);

      if (response['status'] == 'OK') {
        var predictionJson = response['predictions'];

        var theList = (predictionJson as List)
            .map((e) => Prediction.fromJson(e))
            .toList();

        setState(() {
          destinationPredictionList = theList;
          setState(() {
            state = 'fetched';
          });
        });
      }
    } else {
      setState(() {
        destinationPredictionList.clear();
        setState(() {
          state = 'idle';
        });
      });
    }
  }

  Future<dynamic> getRequest(var url) async {
    http.Response response = await http.get(Uri.parse(url));

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



  Future initializer()async{


    var addressDetails = await getSharedPrefManager.getPrefPickupAddress();

    address = addressDetails?.placeName ?? '';

    isPickup = address == null;

    if (address == ''){
      setState(() {
        isPickup = true;
      });
    }

    pickupController.text = address;

    setFocus();
  }





  @override
  void initState() {

    initializer();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<SearchRideViewModel>.reactive(
      viewModelBuilder: () => SearchRideViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //SEARCH INPUT AREA
                    Container(
                      height: 200,
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        border: Border(bottom: BorderSide(color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.surface, width: 3)),
                        boxShadow: [
                          BoxShadow(
                              color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onBackground.withOpacity(0.0),
                              spreadRadius: 0.5,
                              blurRadius: 5,
                              offset: Offset(0, 9) // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [

                          //AppBar
                          Container(
                            height: 56,
                            width: size.width,
                            margin: EdgeInsets.only(top: 10),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      'assets/icons/icon-close-back-black.svg',
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    padding: EdgeInsets.all(2.0),
                                    //fillColor: ViellyThemeColor_whiteBack,
                                    elevation: 0,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    "${AppLocalizations.of(context)!.enterDestination}",
                                    style: Theme.of(context).textTheme.headline6!.apply(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                ), //Page Header Text
                                Container(
                                  margin: EdgeInsets.only(right: size.width * 0.05),
                                  height: 47,
                                  width: 47,
                                ),
                              ],
                            ),
                          ),

                          //Search Area
                          Container(
                            //color: Colors.grey[400],
                            width: size.width * 0.88,
                            margin: EdgeInsets.only(
                                left: size.width * 0.06,
                                right: size.width * 0.06,
                                top: 13),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        child: SvgPicture.asset(
                                            'assets/icons/seticon1.svg', color: Theme.of(context).colorScheme.primary),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          padding: EdgeInsets.only(
                                            left: 14,
                                            right: 0,
                                            bottom:2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.surface,
                                            borderRadius:
                                            BorderRadius.circular(15.00),
                                          ),
                                          child: TextField(
                                            style: Theme.of(context).textTheme.bodyText1,
                                            keyboardType: TextInputType.text,
                                            textCapitalization:
                                            TextCapitalization.words,
                                            cursorColor: Theme.of(context).colorScheme.primary,
                                            controller: pickupController,

                                            //initialValue: address,
                                            onChanged: (value) {
                                              searchPlace(value);
                                            },

                                            decoration: InputDecoration(
                                              hintText: AppLocalizations.of(context)!.currentLocation,
                                              hintStyle:
                                              Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.primary),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                new BorderRadius.circular(12.0),
                                              ),
                                              suffixIcon: Container(
                                                height: 5,
                                                width: 5,
                                                padding: EdgeInsets.all(10),
                                                child: RawMaterialButton(
                                                  padding: EdgeInsets.all(0),
                                                  elevation: 0,
                                                  fillColor: Theme.of(context).colorScheme.error,
                                                  shape: CircleBorder(),
                                                  onPressed: (){
                                                    pickupController.clear();
                                                    //getSharedPrefManager.setPrefPickupAddress(null);


                                                    setState(() {
                                                      isPickup = true;
                                                    });
                                                    print('isPickup True set');
                                                  },

                                                  child: Container(
                                                      padding: EdgeInsets.all(7),
                                                      child:
                                                      SvgPicture.asset('assets/icons/icon-close-back-black.svg',
                                                        color:  Theme.of(context).colorScheme.background,)
                                                  ),
                                                ),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ), //TextBox
                                    ],
                                  ),
                                ), //TextRow
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        child: SvgPicture.asset(
                                            'assets/icons/seticon2.svg', color: Theme.of(context).colorScheme.secondary),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          padding: EdgeInsets.only(
                                            left: 14,
                                            right: 14,
                                            bottom: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.surface,
                                            borderRadius:
                                            BorderRadius.circular(15.00),
                                          ),
                                          child: TextField(
                                            textAlignVertical: TextAlignVertical.top,
                                            style: Theme.of(context).textTheme.bodyText1,
                                            keyboardType: TextInputType.text,
                                            textCapitalization: TextCapitalization.words,
                                            cursorColor: Theme.of(context).colorScheme.secondary,
                                            onChanged: (value) {
                                              print('Search place work');
                                              searchPlace(value);
                                            },
                                            controller: destinationController,
                                            focusNode: destinationFocus,
                                            decoration: InputDecoration(
                                              hintText: AppLocalizations.of(context)!.whereTo,
                                              hintStyle: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.onBackground),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                new BorderRadius.circular(12.0),
                                              ),
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ), //TextBox
                                    ],
                                  ),
                                ), //TextRow
                              ],
                            ),
                          ),
                        ],
                      ),
                    ), //Search Side

                    //SEARCH RESULT AREA
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            //FIND BY BUS ROUTE
                            Container(
                              width: size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                                    child: Text(
                                      "${AppLocalizations.of(context)!.findByRoute}",
                                      style: Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.onSurface),
                                    ),
                                  ),

                                  InkWell(
                                    onTap: (){

                                      model.getNavigator.navigateTo(Routes.availableBusRoutesView);

                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                                      height: 45,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.primary,
                                                shape: BoxShape.circle
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Text(
                                            "${AppLocalizations.of(context)!.viewBusRoutes}",
                                            style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),



                                ],
                              ),
                            ),


                            //Search Results
                            Container(
                              child: Column(
                                children: [
                                  (state == 'fetched') ?
                                  Container(
                                    width: size.width,
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                                    child: Text(
                                      "${AppLocalizations.of(context)!.findByLocation}",
                                      style: Theme.of(context).textTheme.caption!.apply(color: Theme.of(context).colorScheme.onSurface),
                                    ),
                                  ) : Container(),

                                  ListView.separated(
                                    itemBuilder: (context, index) {
                                      return (state == 'fetched')
                                          ?
                                        PredictionTile(
                                          isPickup: isPickup,
                                          isSaveLocation: false,
                                          prediction: destinationPredictionList[index],
                                          onDestinationSelected: widget.onDestinationSelected,
                                          isEditLocation: false,
                                          onPickupSelected: (address) {
                                            pickupController.text = address.placeName;
                                            print('OnPickupSelected');

                                            setState(() {
                                              isPickup = false;
                                            });

                                            destinationFocus.requestFocus();
                                          })
                                          :
                                          (state == 'loading')
                                              ?
                                          EmptyPredictionTile()
                                              :
                                          (state == 'idle') ? Container(/*todo search history*/) : Container(/*todo error*/); //todo ride history or search history
                                    },
                                    separatorBuilder: (BuildContext context, int index) => Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.06,
                                      ),
                                      child: Divider(
                                        color: Theme.of(context).colorScheme.background,
                                        height: 5,
                                        thickness: 1,
                                        indent: 0,
                                        endIndent: 0,
                                      ),
                                    ),
                                    itemCount: (destinationPredictionList.length == 0) ? 3 : destinationPredictionList.length,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

