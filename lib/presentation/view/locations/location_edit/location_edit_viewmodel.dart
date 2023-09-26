

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../app/app.router.dart';
import '../../../../data/models/savedlocations.dart';
import '../../view_model.dart';

class EditLocationViewModel extends ViewModel {

  String _isTagValid = 'null';
  get isTagValid => _isTagValid;

  SavedLocationModel? _addressDetails;
  get addressDetails => _addressDetails;

  LatLng? _addressLatLng;
  get addressLatLng => _addressLatLng;

  String? _addressName;
  get addressName => _addressName;


  bool _isHome = false;
  get isHome => _isHome;

  bool _isWork = false;
  get isWork => _isWork;

      

  TextEditingController tagController = TextEditingController();
  FocusNode tagFocusNode = FocusNode();


  Future initializer({isHome,isWork, savedAddress,context})async{

    if(isHome){
      _isHome = true;
      notifyListeners();
    }else if(isWork){
      _isWork = true;
      notifyListeners();
    }

    _addressDetails = savedAddress;
    _addressLatLng = LatLng(savedAddress.location.latitude, savedAddress.location.longitude);
    _addressName = savedAddress.name;
    notifyListeners();

    tagController.text = savedAddress.tag;

    controllerFocus(context);
  }

  Future navigateToSearch()async{
    var result = await getNavigator.navigateTo(
        Routes.searchLocationView,
        arguments: SearchLocationViewArguments(
          isWork: false,
          isHome: false,
          isEditLocation: true,
        )
    );

    if (result != null){
      _addressLatLng = LatLng(result.latitude, result.longitude);
      _addressName = result.placeName;
      notifyListeners();
    }
  }

  void controllerFocus(context) {

    //nameController.text = '';
    tagController.addListener(() {
      notifyListeners();// setState every time text changes
    });

    //FocusScope.of(context).requestFocus(tagFocusNode);

  }

  void setIsTagValid(bool value){

    if(value == true){
      _isTagValid = 'true';
      notifyListeners();
    }else{
      _isTagValid = 'false';
      notifyListeners();
    }

  }

  Future editNewLocation()async{

    print(tagController.text);

    showLoadingDialog('Loading', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    final Map<String, dynamic> data = Map<String, dynamic>();

    if(isHome){
      data['tag'] = '####HOME';
    }else if(isWork){
      data['tag'] = '####WORK';
    }else{
      data['tag'] = tagController.text;
    }
    data['saved_location_id'] = addressDetails.savedLocationID;
    data['name'] = addressName;
    data['location'] =  {
      "latitude": addressLatLng.latitude,
      "longitude": addressLatLng.longitude,
    };


    final bool isSuccess = await getUserRepositoryImpl.patchSavedLocation(data);

    if(isSuccess){

      await fetchSavedLocationData(fromRemote: true);

      dismissLoadingDialog();

      getNavigator.back(result: true);


    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: 'Updating the location failed',
          description: 'Sorry we could not update the location. Please try again.',
          mainTitle: 'RETRY',
          secondTitle: 'CANCEL'
      ).then((value) {
        if(value){
          this.editNewLocation();
        }else if(!(value)){
          return;
        }
      });
    }


  }

  Future deleteConfirmation()async{

    await showDialogConfirmRed(
        title: 'Delete saved location?',
        description: 'If you choose delete, this location will be deleted',
        mainTitle: 'DELETE',
        secondTitle: 'CANCEL'
    ).then((value) async{
      if((value)){
        print('true');
        await deleteLocation();
        return;
      } else if(!(value)){
        print('false');
        return;
      }
    });
  }

  Future deleteLocation()async{

    showLoadingDialog('Loading', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    final Map<String, dynamic> data = Map<String, dynamic>();

    print(addressDetails.savedLocationID);
    data['saved_location_id'] = addressDetails.savedLocationID;

    final bool isSuccess = await getUserRepositoryImpl.delSavedLocation(data);

    if(isSuccess){

      await fetchSavedLocationData(fromRemote: true);

      dismissLoadingDialog();

      getNavigator.back(result: true);

    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: 'Deleting this payment method failed',
          description: 'Sorry we could not delete the payment method. Please try again.',
          mainTitle: 'RETRY',
          secondTitle: 'CANCEL'
      ).then((value) {
        if(value){
          this.deleteLocation();
        }else if(!(value)){
          return;
        }
      });
    }


  }

  Future fetchSavedLocationData({bool? fromRemote})async{
    if(fromRemote == true){
      await getUserRepositoryImpl.getSavedLocation(fromRemote: fromRemote);
    }
  }
}