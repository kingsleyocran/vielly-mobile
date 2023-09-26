import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../data/models/bookedbusdata.dart';
import '../../../../data/models/paymentmethods.dart';
import '../../../../app/app.router.dart';
import '../../view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ConfirmBusViewModel extends ViewModel {

  BookedBusSchedule? _bookedBusData;
  get bookedBusData => _bookedBusData;

  int _passengerCount = 1;
  get passengerCount => _passengerCount;


  PaymentMethods? _primaryPaymentMethod;
  get primaryPaymentMethod => _primaryPaymentMethod;

  BuildContext appContext = Get.context!;



  Future navigateToPayTicket() async{
    getNavigator.navigateTo(Routes.payTicketView);
  }


  Future initialized()async{

    await getBookBusData();

    var isPayment = await getSharedPrefManager.getPrefIsPrimaryMethod();
    _primaryPaymentMethod = isPayment;


    notifyListeners();

  }

  Future getBookBusData() async{
    _bookedBusData = await getSharedPrefManager.getBookTicketData();
    notifyListeners();
  }

  Future increaseCounter() async{
    if(passengerCount < bookedBusData.availableSeats){
      _passengerCount++;
      notifyListeners();
    }

  }

  Future decreaseCounter() async{

    if(passengerCount > 1){
      _passengerCount--;
      notifyListeners();
    }

  }

  //CONFIRM BUS
  Future confirmBusTrip() async{

    showLoadingDialog('${AppLocalizations.of(appContext)!.loading}', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    print('DATA#####################');
    print(bookedBusData.orderID);
    print(passengerCount);

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['order_id'] = bookedBusData.orderID;
    data['seats_count'] = passengerCount;

    final value  = await getBusTripRepositoryImpl.postConfirmTicket(data);

    if(value != false){
      dismissLoadingDialog();

      getNavigator.navigateTo(
          Routes.ticketView,
          arguments: TicketViewArguments(
            ticketDetails: value,
          )
      );


      ///todo to change back
      /*
      if(primaryPaymentMethod != null){

        if(primaryPaymentMethod.provider == 'vodafone'){
          getNavigator.navigateTo(Routes.payTicketView);
        }else{
          //showSnackBarGreenAlert('Profile updated');
          getNavigator.navigateTo(
              Routes.ticketView,
              arguments: TicketViewArguments(
                ticketDetails: value,
              )
          );
        }



      }else return;

       */


    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: '${AppLocalizations.of(appContext)!.bookingBusTripFailed}',
          description: '${AppLocalizations.of(appContext)!.sorryWeCouldNotBusTrip}',
          mainTitle: '${AppLocalizations.of(appContext)!.retry}',
          secondTitle: '${AppLocalizations.of(appContext)!.cancel}'
      ).then((value){
        if(value){
          this.confirmBusTrip();
        }else if(!(value)){
          return;
        }
      });
    }
  }

  Future navigateToNextScreen()async{

    if(primaryPaymentMethod != null){

      if(primaryPaymentMethod.provider == 'vodafone'){
        getNavigator.navigateTo(Routes.payTicketView);
      }else{
        //showSnackBarGreenAlert('Profile updated');
        getNavigator.navigateTo(
          Routes.ticketView,
        );
      }

    }else return;

  }
}