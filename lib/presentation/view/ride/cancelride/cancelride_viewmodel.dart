import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/models/searchtripdata.dart';
import '../../view_model.dart';


class CancelRideViewModel extends ViewModel {

  TextEditingController? _reasonController;
  get reasonController => _reasonController;

  FocusNode? _reasonFocusNode;
  get reasonFocusNode => _reasonFocusNode;


  bool _otherIsClicked = false;
  get otherIsClicked => _otherIsClicked;

  bool _isCancelled = false;
  get isCancelled => _isCancelled;

  SearchTripDetails? _searchTripDetails;
  get searchTripDetails => _searchTripDetails;

  String _reason = '';
  get reason => _reason;

  bool _reasonTextEmpty = false;
  get reasonTextEmpty => _reasonTextEmpty;


  initialise() async{

    controllerListener();

  }


  void controllerListener() async{

    reasonController.addListener(() {
      notifyListeners();
    });

  }

  void getProfileDetails(String reason){
    _reason = reason;

    notifyListeners();
  }

  void setIsClicked(bool value){
    _otherIsClicked = value;

    notifyListeners();

  }

  void setReasonText(String value){
    _reason = value;
    notifyListeners();

  }

  //CANCEL RIDE
  Future cancelRide() async{

    showLoadingDialog('Loading', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    setBusy(true);

    _searchTripDetails = await getSharedPrefManager.getPrefSearchTrip();
    notifyListeners();

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['order_id'] = searchTripDetails.orderID;
    data['reason'] = reason;

    final bool isCreated = await getTripRepositoryImpl.postCancelTrip(data);

    if(isCreated){
      dismissLoadingDialog();

      await cancelRealtimeRide();

      _isCancelled = true;
      notifyListeners();

      //showSnackBarGreenAlert('Ride Cancelled');

      navigateBackLogic();

    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: 'Cancelling your ride order failed',
          description: 'We could not cancel your ride order. Please try again.',
          mainTitle: 'RETRY',
          secondTitle: 'CANCEL'
      ).then((value) {
        if(value){
          this.cancelRide();
        }else if(!(value)){
          return;
        }
      });
    }


  }

  Future cancelRealtimeRide() async{
    var rideID = await getSharedPrefManager.getPrefTrip();

    if(rideID != null){
      FirebaseDatabase.instance.reference().child('riders/${rideID.rideID}/trip').update({
        'status': 'cancelled'
      });
    }
  }

  //Reason tile
  Widget reasonTile(BuildContext context, String messageReason){

    var reason = new RawMaterialButton(
      onPressed: (){

        _reason = messageReason;
        notifyListeners();

        cancelRide();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 55,
        //width: size.width * 0.88,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              child: Text(
                messageReason,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SvgPicture.asset('assets/icons/arrowforward.svg'),
          ],
        ),
      ),
    );

    return reason;
  }

  Future navigateBackLogic() async{

    if(isCancelled){
      getNavigator.back(result: true);
    }else{
      getNavigator.back();
    }

  }

}