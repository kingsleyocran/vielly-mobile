import 'package:pull_to_refresh/pull_to_refresh.dart';


import 'package:curve/app/app.router.dart';
import 'package:curve/data/models/ticket.dart';
import 'package:curve/data/models/user.dart';
import 'package:curve/enums/enums.dart';
import 'package:curve/presentation/view/view_model.dart';

class AllTicketViewModel extends ViewModel {

  TicketDetails? _ticketDetails;
  get ticketDetails => _ticketDetails;

  UserDetails? _userProfile;
  get userProfile => _userProfile;

  List<TicketDetails> _ticketDetailsList = [];
  get ticketDetailsList => _ticketDetailsList;

  LoadingState _loadingState = LoadingState.idle;
  get loadingState => _loadingState;

  Future navigatePOP() async{
    getNavigator.popRepeated(3);
  }

  Future initialized() async{

    await fetchSavedTickets();
  }


  Future fetchSavedTickets() async{

    _loadingState = LoadingState.loading;
    notifyListeners();

    var savedTicket = await getBusTripRepositoryImpl.getAllTickets(fromRemote: false);
    if(savedTicket == null){
      _loadingState = LoadingState.onFailed;
      notifyListeners();
    }else{
      _ticketDetailsList = savedTicket;
      notifyListeners();

      _loadingState = LoadingState.fetched;
      notifyListeners();
    }

  }

  Future fetchSavedTicketsRemote() async{

    _loadingState = LoadingState.loading;
    notifyListeners();

    await getBusTripRepositoryImpl.getAllTickets(fromRemote: true);

    var savedTicket = await getBusTripRepositoryImpl.getAllTickets(fromRemote: false);

    if(savedTicket == null){
      _loadingState = LoadingState.onFailed;
      notifyListeners();

      return false;
    }else{

      _ticketDetailsList = savedTicket;
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
    bool result = await fetchSavedTicketsRemote();
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