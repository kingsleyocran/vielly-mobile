
import '../../../../app/app.router.dart';
import '../../../../data/models/savedlocations.dart';
import '../../../../enums/enums.dart';

import '../../view_model.dart';

class LocationOptionViewModel extends ViewModel {

  LoadingState _loadingState = LoadingState.idle;
  get loadingState => _loadingState;

  List<SavedLocationModel> _savedLocationList = [];
  get savedLocationList => _savedLocationList;


  Future initializer()async{


    fetchSavedLocationData( fromRemote: false);

  }

  Future fetchSavedLocationData({bool? fromRemote})async{
    _loadingState = LoadingState.loading;
    notifyListeners();

    if(fromRemote == true){
      await getUserRepositoryImpl.getSavedLocation(fromRemote: fromRemote);
    }

    var locationData = await getSharedPrefManager.getPrefSavedLocations();

    if(locationData == null && fromRemote == false){

      _loadingState = LoadingState.empty;
      notifyListeners();
      return;

    }else if(locationData != null && fromRemote == true){

      _savedLocationList = locationData.cast<SavedLocationModel>();
      _loadingState = LoadingState.fetched;
      notifyListeners();

      return;
    }
    else if(locationData != null && fromRemote == false){

      _savedLocationList.clear();
      notifyListeners();

      _savedLocationList = locationData.cast<SavedLocationModel>();
      _loadingState = LoadingState.fetched;
      notifyListeners();

      return;

    }
    else{
      _loadingState = LoadingState.onFailed;
      notifyListeners();
      return;
    }
  }

  Future navigateAddLocation() async{

    print('Navigate to Add Location');

    bool result = await getNavigator.navigateTo(
        Routes.searchLocationView,
        arguments: SearchLocationViewArguments(
          isWork: false,
          isHome: false,
          isEditLocation: false,
        )
    );
    if(result == null){
      await fetchSavedLocationData(fromRemote: false);
      print('WORKS########################SSSSSSSSS');

      notifyListeners();
    }else if(result){
      await fetchSavedLocationData(fromRemote: false);
      print('WORKS########################SSSSSSSSS');

      showSnackBarGreenAlert('Location saved successfully');
      notifyListeners();

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

  Future navigateEditLocation (SavedLocationModel value)async{

    if(value.tag == '####HOME'){
      bool result = await getNavigator.navigateTo(Routes.editLocationView,
          arguments: EditLocationViewArguments(
            savedLocation: value,
            isWorkTag: false,
            isHomeTag: true,
          )
      );
      if(result == null){
        await fetchSavedLocationData(fromRemote: false);
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocationData(fromRemote: false);
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Saved location edited successfully');
        notifyListeners();
      }

    }
    else if(value.tag == '####WORK'){
      bool result = await getNavigator.navigateTo(Routes.editLocationView,
          arguments: EditLocationViewArguments(
            savedLocation: value,
            isWorkTag: true,
            isHomeTag: false,
          )
      );
      if(result == null){
        await fetchSavedLocationData(fromRemote: false);
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocationData(fromRemote: false);
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Saved location edited successfully');
        notifyListeners();
      }

    }
    else{
      bool result = await getNavigator.navigateTo(Routes.editLocationView,
          arguments: EditLocationViewArguments(
            savedLocation: value,
            isWorkTag: false,
            isHomeTag: false,
          )
      );
      if(result == null){
        await fetchSavedLocationData(fromRemote: false);
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocationData(fromRemote: false);
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Saved location edited successfully');
        notifyListeners();
      }

    }


  }



}