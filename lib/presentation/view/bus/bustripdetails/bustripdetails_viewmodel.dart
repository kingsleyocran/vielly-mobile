
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked_services/stacked_services.dart';


import '../../../../data/models/busschedule_data.dart';
import '../../../../enums/enums.dart';
import '../../../../presentation/widgets/setup_bottomsheet_ui.dart';
import '../../../../presentation/widgets/setup_snackbar_ui.dart';
import '../../../../app/app.router.dart';
import '../../view_model.dart';

class BusTripDetailsViewModel extends ViewModel {

  LoadingState _loadingState = LoadingState.idle;
  get loadingState => _loadingState;

  bool? _isGetData;
  get isGetData => _isGetData;

  List<BusSchedule> _busScheduleList = [];
  get busScheduleList => _busScheduleList;

  BusSchedule? _busSchedule;
  get busSchedule => _busSchedule;

  BusSchedule? _scheduleDetails;
  get scheduleDetails => _scheduleDetails;


  String? _selectedPickupTerminalID;
  get selectedPickupTerminalID => _selectedPickupTerminalID;

  String? _selectedDropOffTerminalID;
  get selectedDropOffTerminalID => _selectedDropOffTerminalID;

  String? _selectedLaneID;
  get selectedLaneID => _selectedLaneID;

  String? _selectedTime;
  get selectedTime => _selectedTime;

  String? _selectedLane;
  get selectedLane => _selectedLane;

  String? _selectedPickupTerminal;
  get selectedPickupTerminal => _selectedPickupTerminal;

  String? _selectedDropOffTerminal;
  get selectedDropOffTerminal => _selectedDropOffTerminal;

  String? _selectedDateConverted;
  get selectedDateConverted => _selectedDateConverted;

  String? _selectedDate;
  get selectedDate => _selectedDate;

  BuildContext context = Get.context!;







  Future initializer({BusSchedule? valueSch, BusSchedule? value, List<BusSchedule>? valueList})async{

    _loadingState = LoadingState.loading;
    notifyListeners();

    if (valueSch != null && valueList != null){
      _loadingState = LoadingState.fetched;

      _scheduleDetails = valueSch;
      _busScheduleList = valueList;
      notifyListeners();

      _selectedTime = scheduleDetails.startTime;
      _selectedDate = scheduleDetails.date;
      notifyListeners();

      print('Schedule Details passed = $selectedTime and $selectedDate');

    }
    else if (value != null){
      _loadingState = LoadingState.fetched;

      _busSchedule = value;
      notifyListeners();

      _selectedLane = busSchedule.laneName;
      _selectedTime = busSchedule.startTime;
      _selectedDate = busSchedule.date;
      _selectedLaneID = busSchedule.laneID;
      notifyListeners();

      print('Bus Details passed = $selectedLaneID, $selectedLane, $selectedTime and $selectedDate');

    }else if(valueList != null){


      _busScheduleList = valueList;
      _loadingState = LoadingState.fetched;

      notifyListeners();
    }
    else{
      getBusSchedules();
    }


  }

  Future openLaneBottomSheet() async{

    //busScheduleList.forEach((e) => laneList.add(e.laneName));

    var ids = busScheduleList.map((e) => e.laneName).toSet().toList();
    print(ids);
    //var laneList = (busScheduleList.retainWhere((e) => ids.add(e.laneID))).toList();


    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.busLane,
      title: AppLocalizations.of(context)!.selectBusLane,
      description: selectedLane??'',
      data: ids,
      isScrollControlled: true,
    );

    if(confirmationResponse!.data == null){return;}
    print( 'confirmationResponse confirmed: ${confirmationResponse.data}');

    _selectedLane = confirmationResponse.data;
    notifyListeners();

    int indexLane = busScheduleList.indexWhere((e) => e.laneName == selectedLane);
    _selectedLaneID = busScheduleList[indexLane].laneID;
    notifyListeners();

    print(selectedLaneID);
  }

  Future openPickupBottomSheet() async{
    if(selectedLane == null){
      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: AppLocalizations.of(context)!.makeSureYouHaveSelectBusLane ,
      );
      return;
    }

    var pickupList;

    if(busSchedule != null){
      pickupList = busSchedule.busTerminal;
    }else{
      int index = busScheduleList.indexWhere((e) => e.laneID == selectedLaneID);
      pickupList = busScheduleList[index].busTerminal;
    }


    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.busTerminal,
      title: AppLocalizations.of(context)!.pickupTerminal,
      description: selectedPickupTerminalID.toString(),
      data: pickupList,
      isScrollControlled: true,

    );

    if(confirmationResponse!.data == null){return;}
    print( 'confirmationResponse confirmed: ${confirmationResponse.data}');

    _selectedPickupTerminalID = confirmationResponse.data;
    notifyListeners();

    int indexPick = pickupList.indexWhere((e) => e.busTerminalID == selectedPickupTerminalID);
    _selectedPickupTerminal = pickupList[indexPick].busTerminalName;
    notifyListeners();
  }

  Future openDropOffBottomSheet() async{
    if(selectedLane == null){
      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: AppLocalizations.of(context)!.makeSureYouHaveSelectBusLane,
      );
      return;
    }


    var dropoffList;

    if(busSchedule != null){
      dropoffList = busSchedule.busTerminal;
    }else{
      int index = busScheduleList.indexWhere((e) => e.laneID == selectedLaneID);
      dropoffList = busScheduleList[index].busTerminal;
    }


    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.busTerminal,
      title: AppLocalizations.of(context)!.dropOffTerminal,
      description: selectedDropOffTerminalID.toString(),
      data: dropoffList,
      isScrollControlled: true,
    );

    if(confirmationResponse!.data == null){return;}
    print( 'confirmationResponse confirmed: ${confirmationResponse.data}');

    _selectedDropOffTerminalID = confirmationResponse.data;
    notifyListeners();

    int indexPick = dropoffList.indexWhere((e) => e.busTerminalID == selectedDropOffTerminalID);
    _selectedDropOffTerminal = dropoffList[indexPick].busTerminalName;
    notifyListeners();
  }

  Future openTimeBottomSheet() async{
    if(selectedLane == null){
      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: AppLocalizations.of(context)!.makeSureYouHaveSelectBusLane,
      );
      return;
    }

    int index = busScheduleList.indexWhere((e) => e.laneID == selectedLaneID);
    var opTimeList = busScheduleList[index].laneOperatingTimes;

    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.busTime,
      title: AppLocalizations.of(context)!.busTripTime,
      description: selectedTime??'',
      data: opTimeList,
      isScrollControlled: true,
    );

    if(confirmationResponse!.data == null){return;}
    print( 'confirmationResponse confirmed: ${confirmationResponse.data}');

    _selectedTime = confirmationResponse.data;
    notifyListeners();

  }

  Future openDateBottomSheet() async{

    if(selectedLane == null){
      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: AppLocalizations.of(context)!.makeSureYouHaveSelectBusLane,
      );
      return;
    }

    int index = busScheduleList.indexWhere((e) => e.laneID == selectedLaneID);
    var pickupList = busScheduleList[index].busTerminal;

    var confirmationResponse =
    await getBottomSheet.showCustomSheet(
      variant: BottomSheetType.busDate,
      title: AppLocalizations.of(context)!.selectDate,
      description: selectedDropOffTerminalID.toString(),
      data: pickupList,
      isScrollControlled: true,
    );

    if(confirmationResponse!.data == null){return;}
    print( 'confirmationResponse confirmed: ${confirmationResponse.data}');

    final rawDate = confirmationResponse.data;

    _selectedDate = (DateFormat('MM/dd/yyyy').format(rawDate)).toString();
    notifyListeners();

    //_selectedDate = DateFormat('EEE - d MMM, yyyy').format(DateFormat('yMd').parse(widget.busSchedule.date))

    _selectedDateConverted = (DateFormat('EEE - d MMM, yyyy').format(rawDate)).toString();
    notifyListeners();

    print('Dates = $selectedDate and $_selectedDateConverted');

  }

  selectDate(context) async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime? tempPickedDate;
        return Container(
          height: 400,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;

                      print(tempPickedDate.toString());
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    print(pickedDate.toString());

    /*
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _textEditingController.text = pickedDate.toString();
      });
    }

     */
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

      return;
    }

    notifyListeners();

    await getBusTripRepositoryImpl.getBusSchedules();

    var busData = await getSharedPrefManager.getPrefBusSchedules();

    if(busData != null){

      _busScheduleList = busData.cast<BusSchedule>();
      _isGetData = false;
      _loadingState = LoadingState.fetched;
      notifyListeners();

      print(busScheduleList);

    }else{
      _loadingState = LoadingState.onFailed;
      notifyListeners();

      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: AppLocalizations.of(context)!.couldNotSomethingWentWrong,
      );
    }
  }

  //BOOK BUS
  Future bookBusTrip() async{

    showLoadingDialog(AppLocalizations.of(context)!.loading, false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    setBusy(true);

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['lane'] = selectedLaneID;
    data['date'] = selectedDate;
    data['time'] = selectedTime;
    data['pickup'] = selectedPickupTerminalID;
    data['dropoff'] = selectedDropOffTerminalID;


    final bool isSuccess  = await getBusTripRepositoryImpl.postBookTicket(data);

    if(isSuccess){
      dismissLoadingDialog();

      //showSnackBarGreenAlert('Profile updated');
      await getNavigator.navigateTo(Routes.confirmBusView);

    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: AppLocalizations.of(context)!.bookingBusTripFailed,
          description: AppLocalizations.of(context)!.sorryWeCouldNotBusTrip,
          mainTitle: AppLocalizations.of(context)!.retry,
          secondTitle: AppLocalizations.of(context)!.cancel
      ).then((value) {
        if(value){
          this.bookBusTrip();
        }else if(!(value)){
          return;
        }
      });
    }
  }

  Future navigateToBusDetails() async{
    getNavigator.navigateTo(Routes.confirmBusView);
  }




}
