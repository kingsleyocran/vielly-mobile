import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:curve/data/models/ridehistory_data.dart';
import 'package:curve/app/app.router.dart';
import 'package:curve/data/models/user.dart';
import 'package:curve/enums/enums.dart';
import 'package:curve/presentation/view/view_model.dart';

class RideHistoryViewModel extends ViewModel {

  RideHistory? _rideHistory;
  get rideHistory => _rideHistory;

  UserDetails? _userProfile;
  get userProfile => _userProfile;

  List<RideHistory> _rideHistoryList = [];
  get rideHistoryList => _rideHistoryList;

  LoadingState _loadingState = LoadingState.idle;
  get loadingState => _loadingState;

  Future navigatePOP() async{
    getNavigator.popRepeated(3);
  }

  Future initialized() async{

    await fetchSavedRideHistory();
  }


  Future fetchSavedRideHistory() async{

    _loadingState = LoadingState.loading;
    notifyListeners();

    var savedHistory = await getUserRepositoryImpl.getRideHistory(fromRemote: false);
    if(savedHistory == null){
      _loadingState = LoadingState.onFailed;
      notifyListeners();
    }else{
      _rideHistoryList = savedHistory;
      notifyListeners();

      _loadingState = LoadingState.fetched;
      notifyListeners();
    }

  }

  Future fetchSavedRideHistoryRemote() async{

    _loadingState = LoadingState.loading;
    notifyListeners();

    await getBusTripRepositoryImpl.getAllTickets(fromRemote: true);

    var savedHistory = await getBusTripRepositoryImpl.getAllTickets(fromRemote: false);

    if(savedHistory == null){
      _loadingState = LoadingState.onFailed;
      notifyListeners();

      return false;
    }else{

      _rideHistoryList = savedHistory;
      notifyListeners();

      _loadingState = LoadingState.fetched;
      notifyListeners();

      return true;
    }
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
    bool result = await fetchSavedRideHistoryRemote();
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