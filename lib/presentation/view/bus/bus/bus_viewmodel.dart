import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:curve/data/models/busschedule_data.dart';
import 'package:curve/data/models/ticket.dart';
import 'package:curve/enums/enums.dart';
import 'package:curve/presentation/widgets/setup_snackbar_ui.dart';
import 'package:curve/app/app.router.dart';
import '../../view_model.dart';

@lazySingleton
class BusViewModel extends ViewModel {

  LoadingState _loadingState = LoadingState.idle;
  get loadingState => _loadingState;

  List<BusSchedule> _busScheduleList = [];
  get busScheduleList => _busScheduleList;

  List<TicketDetails> _ticketDetailsList = [];
  get ticketDetailsList => _ticketDetailsList;

  bool _busSchGet = false;
  get busSchGet => _busSchGet;


  Future initialized()async{

    await fetchSavedTickets();

    await getBusSchedules();

    Timer.periodic(Duration(minutes: 60), (timer) async {
      await getBusSchedules();
    });



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
        message: "Could not refresh. Make sure you're connected to the internet",
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
        message: "Could not refresh. Something went wrong",
      );

      return false;
    }
  }

  Future navigateToBusDetails() async{
    if(busScheduleList == null){
      showSnackBarRedAlert('There are no bus schedules available. Make sure to reload the bus schedules');
      return;
    }

    bool result = await getNavigator.navigateTo(Routes.busTripDetailsView,
        arguments: BusTripDetailsViewArguments(
          busScheduleList: busScheduleList,
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




  //PULL TO REFRESH
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
}