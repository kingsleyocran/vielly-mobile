import 'dart:collection';

import 'package:curve/data/models/busschedule_data.dart';
import 'package:curve/presentation/widgets/setup_snackbar_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:curve/app/app.router.dart';
import 'package:curve/data/models/ticket.dart';
import 'package:curve/data/models/user.dart';
import 'package:curve/enums/enums.dart';
import 'package:curve/presentation/view/view_model.dart';
import 'package:stacked_services/stacked_services.dart';

class AvailableBusRoutesViewModel extends ViewModel {


  List<BusSchedule> _busScheduleList = [];
  get busScheduleList => _busScheduleList;

  List<BusSchedule> _unSortedBusScheduleList = [];
  get unSortedBusScheduleList => _unSortedBusScheduleList;

  BusSchedule? _busSchedule;
  get busSchedule => _busSchedule;

  UserDetails? _userProfile;
  get userProfile => _userProfile;

  LoadingState _loadingState = LoadingState.idle;
  get loadingState => _loadingState;

  BuildContext context = Get.context!;


  Future navigatePOP() async{
    getNavigator.popRepeated(3);
  }

  Future initialized() async{

    bool result = await getBusSchedules(fromRemote: false);

    if (result == false){
      await getBusSchedules(fromRemote: false);
    }
  }


  Future getBusSchedules({required bool fromRemote}) async{
    print('GET BUS ####################################');
    _loadingState = LoadingState.loading;
    notifyListeners();

    if (fromRemote){
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

      await getBusTripRepositoryImpl.getBusSchedules();
    }

    var busData = await getSharedPrefManager.getPrefBusSchedules();

    if(busData != null){

      final List<BusSchedule> buses = busData.cast<BusSchedule>();
      _loadingState = LoadingState.fetched;
      notifyListeners();

      _unSortedBusScheduleList = busData.cast<BusSchedule>();
      _busScheduleList.add(buses[0]);
      notifyListeners();


      for (int i = 1; i < buses.length; i++) {

        if(!(busScheduleList.map((item) => item.laneName).contains(buses[i].laneName))){
          _busScheduleList.add(buses[i]);
          notifyListeners();
        }
      }

    }else{
      return Future.value(false);
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

    }
  }


  //PULL TO REFRESH
  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  void onRefresh() async{
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    bool result = await getBusSchedules(fromRemote: true);
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
}