

import 'package:flutter/material.dart';

import '../../../../data/models/address.dart';
import '../../view_model.dart';

class AddLocationViewModel extends ViewModel {

  String _isTagValid = 'null';
  get isTagValid => _isTagValid;

  AddressDetails? _addressDetails;
  get addressDetails => _addressDetails;

  TextEditingController tagController = TextEditingController();
  FocusNode tagFocusNode = FocusNode();

  bool _isHome = false;
  get isHome => _isHome;

  bool _isWork = false;
  get isWork => _isWork;


  Future initializer({isHome,isWork,address,context})async{

    if(isHome){
      _isHome = true;
      notifyListeners();
    }else if(isWork){
      _isWork = true;
      notifyListeners();
    }

    _addressDetails = address;
    notifyListeners();

    controllerFocus(context);
  }

  void controllerFocus(context) {

    //nameController.text = '';
    tagController.addListener(() {
      notifyListeners();// setState every time text changes
    });

    FocusScope.of(context).requestFocus(tagFocusNode);

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

  Future addNewLocation()async{

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

    data['name'] = addressDetails.placeName;
    data['location'] =  {
      "latitude": addressDetails.latitude,
      "longitude": addressDetails.longitude,
    };



    final bool isSuccess = await getUserRepositoryImpl.postAddSavedLocation(data);

    if(isSuccess){

      await fetchSavedLocationData(fromRemote: true);

      dismissLoadingDialog();

      //getNavigator.back(result: true);
      getNavigator.popRepeated(2);

    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: 'Saving a new location failed',
          description: 'Sorry we could not save the location. Please try again.',
          mainTitle: 'RETRY',
          secondTitle: 'CANCEL'
      ).then((value) {
        if(value){
          this.addNewLocation();
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