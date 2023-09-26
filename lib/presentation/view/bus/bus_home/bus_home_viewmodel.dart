import 'dart:async';
import 'dart:io';

import 'package:curve/presentation/widgets/setup_bottomsheet_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'package:curve/data/models/paymentmethods.dart';
import 'package:curve/data/models/user.dart';
import 'package:curve/data/models/savedlocations.dart';
import 'package:curve/data/models/busschedule_data.dart';
import 'package:curve/data/models/ticket.dart';
import 'package:curve/enums/enums.dart';
import 'package:curve/presentation/widgets/setup_snackbar_ui.dart';
import 'package:curve/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../view_model.dart';


class BusHomeViewModel extends ViewModel {

  LoadingState _loadingState = LoadingState.idle;
  get loadingState => _loadingState;

  List<BusSchedule> _busScheduleList = [];
  get busScheduleList => _busScheduleList;

  List<TicketDetails> _ticketDetailsList = [];
  get ticketDetailsList => _ticketDetailsList;

  bool _busSchGet = false;
  get busSchGet => _busSchGet;




  UserDetails _userProfile = UserDetails();
  get userProfile => _userProfile;

  SavedLocationModel? _isHomeLocation;
  get isHomeLocation => _isHomeLocation;

  List<SavedLocationModel> _savedLocationList = [];
  get savedLocationList => _savedLocationList;

  SavedLocationModel? _isWorkLocation;
  get isWorkLocation => _isWorkLocation;

  PaymentMethods? _isPrimaryMethod;
  get isPrimaryMethod => _isPrimaryMethod;

  String _selectedProvider = 'Cash';
  get selectedProvider => _selectedProvider;

  String? _userPhone;
  get userPhone => _userPhone;

  String? _userID;
  get userID => _userID;

  String? _profilePath;
  get profilePath => _profilePath;

  File? _profileFile;
  get profileFile => _profileFile;

  BuildContext context = Get.context!;


  ///INITIALIZER MAIN//////////////////////////////////////////////
  Future initialized(context) async{

    getCurrentPosition();

    await getProfileDetails();

    await fetchSavedTickets();

    await getBusSchedules();

    Timer.periodic(Duration(minutes: 60), (timer) async {
      await getBusSchedules();
    });


  }




  ///DATA GETTERS//////////////////////////////////////////////
  Future getProfileDetails() async{

    await fetchSavedLocations();

    _userProfile = (await getSharedPrefManager.getPrefUserProfile())!;
    _isPrimaryMethod = await getSharedPrefManager.getPrefIsPrimaryMethod();
    notifyListeners();
    //_userSavedLocation = await getSharedPrefManager.getPrefSavedLocations();
    if(isPrimaryMethod.provider == "mtn"){
      _selectedProvider = 'MTN Mobile Money';
      notifyListeners();
    }else if(isPrimaryMethod.provider == "airteltigo"){
      _selectedProvider = 'AirtelTigo Money';
      notifyListeners();
    }else if(isPrimaryMethod.provider== "vodafone"){
      _selectedProvider = 'Vodafone Cash';
      notifyListeners();
    }else if(isPrimaryMethod.provider== "cash"){
      _selectedProvider = 'Cash';
      notifyListeners();
    }

    print(selectedProvider);
    notifyListeners();

  }

  Future fetchSavedLocations()async{
    var savedLoc = await getSharedPrefManager.getPrefSavedLocations();
    _savedLocationList = savedLoc!.cast<SavedLocationModel>();
    notifyListeners();

    var indexPickH = savedLocationList.indexWhere((e) => e.tag == '####HOME');
    if(indexPickH > -1)
    {_isHomeLocation = savedLocationList[indexPickH];}
    else
    {_isHomeLocation = null;}

    var indexPickW = savedLocationList.indexWhere((e) => e.tag == '####WORK');
    if(indexPickW > -1)
    {_isWorkLocation = savedLocationList[indexPickW];}
    else
    {_isWorkLocation = null;}
    notifyListeners();
  }

  Future fetchSavedTickets() async{

    var savedTicket = await getBusTripRepositoryImpl.getAllTickets(fromRemote: false);
    _ticketDetailsList = savedTicket;
    notifyListeners();

  }

  Future getBusSchedules() async{
    print('GET BUS ####################################');
    _loadingState = LoadingState.loading;
    notifyListeners();

    bool internet = await internetCheckWithOutLoading();

    if(!internet){

      _loadingState = LoadingState.onFailed;
      notifyListeners();


      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: AppLocalizations.of(context)!.couldNotConnectedToInternet,
      );

      return false;
    }

    setBusy(true);

    notifyListeners();

    await getBusTripRepositoryImpl.getBusSchedules();

    var busData = await getSharedPrefManager.getPrefBusSchedules();


    if(busData != null){

      busData.removeWhere((e) => e.seats == 0);
      _busScheduleList = busData.cast<BusSchedule>();
      _busSchGet = true;
      notifyListeners();

      print(busScheduleList);
      _loadingState = LoadingState.fetched;
      notifyListeners();

      return true;

    }else{

      _loadingState = LoadingState.onFailed;
      notifyListeners();


      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: AppLocalizations.of(context)!.couldNotSomethingWentWrong,
      );

      return false;
    }
  }






  ///PULL TO REFRESH///////////////////////
  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  void onRefresh() async{
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    bool result = await getBusSchedules();
    if(result){
      refreshController.refreshCompleted();
    }else{
      refreshController.refreshFailed();
    }
  }

  void onLoading() async{
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    refreshController.loadComplete();
  }






  Future getCurrentPosition() async {
    final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);

    String address = await getLocationService.findCoordinateAddress(position);
    print("GETTING CURRENT LOCATION######################################");
    print(address);
  }


  Future getProfileFromCache() async{
    //_profilePath = await cacheManager.getFile(userProfile.originalImage);}
    _profilePath = null;
    notifyListeners();
    _profileFile = await findPath(userProfile.originalImage);
    notifyListeners();
  }

  Future findPath(String imageUrl) async {
    final cache =  cacheManager;
    final file = await cache.getSingleFile(imageUrl);

    //return file.path;

    File filed = new File(file.path);
    return filed;
  }




  ///NAVIGATORS//////////////////////////////////////////////
  Future navigateToEdit() async {
    /*
    await getNavigator.navigateTo(Routes.editProfileView).then((value) => () async{

      await getProfileFromCache();
      print('SHOULD WORK');
      await getProfileDetails();

      notifyListeners();
    });

     */

    bool? result = await getNavigator.navigateTo(Routes.editProfileView,);
    if(result == null){
      await getProfileFromCache();
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }else if (result){
      await getProfileFromCache();
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }

    //print('Navigate to Edit');
  }

  Future navigateToPaymentOpt() async{

    print('Navigate to PayTrip');

    bool? result = await getNavigator.navigateTo(Routes.paymentOptionView);
    if(result == null){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }else if (result){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }

  }

  Future navigateToRideHistory() async{

    print('Navigate to Ride History');

    bool result = await getNavigator.navigateTo(Routes.rideHistoryView);
    if(result == null){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }else if (result){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }

  }

  Future navigateToSettings() async {
    await getNavigator.navigateTo(Routes.settingsView);
    print('Navigate to Settings');
  }

  Future navigateToSavedLocation() async{

    print('Navigate to Saved Location');

    bool? result = await getNavigator.navigateTo(Routes.locationOptionView);

    if(result == null){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }else if (result){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }

  }

  Future navigateAddHomeWork({bool? isHome}) async{

    if(isHome!){
      print('Navigate to Add Location');

      bool? result = await getNavigator.navigateTo(
          Routes.searchLocationView,
          arguments: SearchLocationViewArguments(
            isWork: false,
            isHome: true,
            isEditLocation: false,
          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert( 'Location saved successfully');
        notifyListeners();
      }
    } else{
      print('Navigate to Add Location');

      bool result = await getNavigator.navigateTo(
          Routes.searchLocationView,
          arguments: SearchLocationViewArguments(
            isWork: true,
            isHome: false,
            isEditLocation: false,
          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Location saved successfully');
        notifyListeners();
      }
    }

    /*
        .then((value){
      if(value){
        fetchPaymentDetails(fromRemote: false);
        showSnackBarGreenAlert('New payment added successfully');
        notifyListeners();
      }
    });

     */
  }

  Future navigateToEditHomeWork ({isHome})async{

    if(isHome){
      bool? result = await getNavigator.navigateTo(Routes.editLocationView,
          arguments: EditLocationViewArguments(
            savedLocation: isHomeLocation,
            isHomeTag: true,
            isWorkTag: false,
          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Saved location edited successfully');
        notifyListeners();
      }


    }else{
      bool result = await getNavigator.navigateTo(Routes.editLocationView,
          arguments: EditLocationViewArguments(
            savedLocation: isWorkLocation,
            isHomeTag: false,
            isWorkTag: true,
          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Saved location edited successfully');
        notifyListeners();
      }


    }
  }

  Future navigateToSearch() async{

    getNavigator.navigateTo(
        Routes.searchRideView,
        arguments: SearchRideViewArguments(
            onDestinationSelected:
                (address) async {
              //Destination was selected
              var pickup = await getSharedPrefManager.getPrefPickupAddress();
              var destination = await getSharedPrefManager.getPrefDropOffAddress();

              print("################## Executed initializeGetDirect function");
              bool? result = await navigateToOnDemandRides();

              if (result == null){
                await fetchSavedTickets();
              }
            }
        ));
  }

  Future navigateToBusDetails() async{
    if(busScheduleList == null){
      showSnackBarRedAlert( AppLocalizations.of(context)!.thereAreNoBusSchedules);
      return;
    }

    bool? result = await getNavigator.navigateTo(Routes.busTripDetailsView,
        arguments: BusTripDetailsViewArguments(
          busScheduleList: busScheduleList,
        ));

    if(result == null){
      await fetchSavedTickets();
    }
  }

  Future navigateToOnDemandRides() async{


    bool? result = await getNavigator.navigateTo(Routes.onDemandRideView,
        arguments: BusTripDetailsViewArguments(
          busScheduleList: busScheduleList,
        ));


    if(result == null){
      await fetchSavedTickets();

      getCurrentPosition();
    }
  }

  Future navigateToBusDetailsSetSchedule({BusSchedule? schedule}) async{
    if(busScheduleList == null){
      showSnackBarRedAlert( AppLocalizations.of(context)!.thereAreNoBusSchedules);
      return;
    }

    bool? result = await getNavigator.navigateTo(Routes.busTripDetailsView,
        arguments: BusTripDetailsViewArguments(
          busScheduleList: busScheduleList,
          schedule: schedule,
        ));

    if(result == null){
      await fetchSavedTickets();
    }
  }

  Future navigateToBusDetailsBusSelect({BusSchedule? busSchedule}) async{
    if(busScheduleList == null){
      showSnackBarRedAlert( AppLocalizations.of(context)!.thereAreNoBusSchedules);
      return;
    }

    bool result = await getNavigator.navigateTo(Routes.busTripDetailsView,
        arguments: BusTripDetailsViewArguments(
          busSchedule: busSchedule!,
        ));


    if(result == null){
      await fetchSavedTickets();
    }else if(result == null){
      await getBusSchedules();
    }
  }

  Future navigateToAllTickets() async{

    getNavigator.navigateTo(Routes.allTicketView,);

  }

  Future navigateToTicket(value)async{
    getNavigator.navigateTo(Routes.bookedTicketView,
        arguments: BookedTicketViewArguments(
            ticketDetails: value
        ));
  }










  ///BUS SCHEDULE FUNCTIONS///////////////////////////////////////

  String? _selectedTime;
  get selectedTime => _selectedTime;

  String? _selectedDateConverted;
  get selectedDateConverted => _selectedDateConverted;

  String? _selectedDate;
  get selectedDate => _selectedDate;

  BusSchedule? _busSchedule;
  get busSchedule => _busSchedule;


  Future openBusScheduleBottomSheet() async{

    var pickupList = busScheduleList[0].busTerminal;

    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.busSchedule,
      title: AppLocalizations.of(context)!.scheduleABusRide,
      description: "selectedDropOffTerminalID.toString()",
      data: pickupList,
      isScrollControlled: true,
    );

    if(confirmationResponse!.data == null){return;}
    print( 'confirmationResponse confirmed: ${confirmationResponse.data}');

    final rawDate = confirmationResponse.data[0];

    _selectedDate = (DateFormat('MM/dd/yyyy').format(rawDate)).toString();
    notifyListeners();

    //_selectedDate = DateFormat('EEE - d MMM, yyyy').format(DateFormat('yMd').parse(widget.busSchedule.date))

    _selectedDateConverted = (DateFormat('EEE - d MMM, yyyy').format(rawDate)).toString();
    notifyListeners();

    _selectedTime = confirmationResponse.data[1];
    notifyListeners();

    print('Dates = $selectedDate and $_selectedDateConverted');

    BusSchedule busScheduleFromSch = BusSchedule(
        startTime: selectedTime,
        date: selectedDate
    );

    navigateToBusDetailsSetSchedule(schedule: busScheduleFromSch,);
  }

}