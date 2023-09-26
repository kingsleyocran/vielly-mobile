
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../../../../data/data_sources/local/sharedpreference.dart';
import '../../../../data/models/address.dart';

import '../../../../data/models/location_prediction.dart';
import '../../../../presentation/widgets/custom_widgets/prediction_tile.dart';
import 'searchlocation_viewmodel.dart';
import '../../../../utilities/statusbar_util.dart';

// ignore: must_be_immutable
class SearchLocationView extends StatefulWidget {

  final Function? onDestinationSelected;
  final bool isEditLocation;
  final bool isHome;
  final bool isWork;

  SearchLocationView({
    required this.isEditLocation,
    required this.isHome,
    required this.isWork,
    this.onDestinationSelected,
    Key? key}) : super(key: key);

  @override
  _SearchLocationViewState createState() => _SearchLocationViewState();
}

class _SearchLocationViewState extends State<SearchLocationView> {

  bool isPickup = false;
  bool isSavedLocation = true;

  final SharedPrefManager _sharedPrefManager = locator<SharedPrefManager>();
  SharedPrefManager get getSharedPrefManager => _sharedPrefManager;


  final NavigationService _navigationService = locator<NavigationService>();
  NavigationService get getNavigationService => _navigationService;

  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  var destinationFocus = FocusNode();

  bool focused = false;
  String address = '';

  AddressDetails? currentAddress;

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

  Future initializer()async{
    var addressDetails = await getSharedPrefManager.getPrefPickupAddress();

    address = addressDetails?.placeName ?? '';

    currentAddress = addressDetails;

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

    return ViewModelBuilder<SearchLocationViewModel>.reactive(
      viewModelBuilder: () => SearchLocationViewModel(),
      builder: (context, model, child) =>
          StatusBarUtil.setStatusBarColorUtil(context,
            Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 145,
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
                                      'assets/icons/icon-arrow-back-black.svg',
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
                                    'Search Location',
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

                          Container(
                            //color: Colors.grey[400],
                            width: size.width * 0.88,
                            margin: EdgeInsets.only(
                                left: size.width * 0.06,
                                right: size.width * 0.06,
                                top: 13),
                            child: Column(
                              children: [
                                /*
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        child: SvgPicture.asset(
                                            'assets/icons/seticon1.svg', color: Theme.of(context).colorScheme.primary,),
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
                                              hintText: "Current Location",
                                              hintStyle:
                                              Theme.of(context).textTheme.bodyText1.apply(color: Theme.of(context).colorScheme.onBackground),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                new BorderRadius.circular(12.0),
                                              ),
                                              /*
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

                                               */
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

                                 */

                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        child: SvgPicture.asset(
                                            'assets/icons/seticon2.svg', color: Theme.of(context).colorScheme.primary),
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
                                            cursorColor: Theme.of(context).colorScheme.primary,
                                            onChanged: (value) {
                                              print('Search place work');
                                              searchPlace(value);
                                            },
                                            controller: destinationController,
                                            focusNode: destinationFocus,
                                            decoration: InputDecoration(
                                              hintText: "Enter Location",
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

                    SizedBox(
                      height: 15,
                    ),

                    //Search Results
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return (state == 'fetched')
                              ?
                            PredictionTile(
                              isPickup: isPickup,
                              isSaveLocation: isSavedLocation,
                              isEditLocation: widget.isEditLocation,
                              prediction: destinationPredictionList[index],
                              onDestinationSelected: widget.onDestinationSelected,
                              onSavedLocationSelect: (address){

                                if(widget.isHome){
                                  getNavigationService.navigateTo(Routes.addLocationView,
                                      arguments: AddLocationViewArguments(
                                        savedAddress: address,
                                        isWorkTag: false,
                                        isHomeTag: true,
                                      ));
                                }else if(widget.isWork){
                                  getNavigationService.navigateTo(Routes.addLocationView,
                                      arguments: AddLocationViewArguments(
                                        savedAddress: address,
                                        isWorkTag: true,
                                        isHomeTag: false,
                                      ));
                                }else{
                                  getNavigationService.navigateTo(Routes.addLocationView,
                                      arguments: AddLocationViewArguments(
                                        savedAddress: address,
                                        isHomeTag: false,
                                        isWorkTag: false,
                                      ));
                                }
                              },
                              onEditLocation: (address){
                                //RETURN ADDRESS VALUE TO SCREEN
                                getNavigationService.back(result: address);
                              },
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
                              (state == 'idle')
                                    ?
                                Container(

                                  child: InkWell(
                                    onTap: (){
                                      if(widget.isEditLocation){
                                        getNavigationService.back(result: currentAddress);
                                      }else{
                                        if(widget.isHome){
                                          getNavigationService.navigateTo(Routes.addLocationView,
                                              arguments: AddLocationViewArguments(
                                                savedAddress: currentAddress!,
                                                isWorkTag: false,
                                                isHomeTag: true,
                                              ));
                                        }else if(widget.isWork){
                                          getNavigationService.navigateTo(Routes.addLocationView,
                                              arguments: AddLocationViewArguments(
                                                savedAddress: currentAddress!,
                                                isWorkTag: true,
                                                isHomeTag: false,
                                              ));
                                        }else{
                                          getNavigationService.navigateTo(Routes.addLocationView,
                                              arguments: AddLocationViewArguments(
                                                savedAddress: currentAddress!,
                                                isHomeTag: false,
                                                isWorkTag: false,
                                              ));
                                        }
                                      }



                                      print('PRINTER');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: size.width * 0.06,
                                        right: size.width * 0.06,
                                      ),
                                      height: 50,
                                      width: size.width * 0.88,
                                      //color: ViellyThemeColor_whiteBack,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/placeicon.svg', color: Theme.of(context).colorScheme.primary,),
                                                SizedBox(width: 15),
                                                Container(
                                                  child: Text(
                                                    'Current Address',
                                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: Theme.of(context).colorScheme.primary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  )
                                    :
                                Container(/*todo error*/); //todo ride history or search history
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
                        itemCount: (destinationPredictionList.length > 0) ?  destinationPredictionList.length : ((state == 'idle')? 1 : 3),
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                      ),
                    )

                    //Place Search results

                    //Search result
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

