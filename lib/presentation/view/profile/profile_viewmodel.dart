



import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:curve/app/app.router.dart';
import 'package:curve/data/models/paymentmethods.dart';
import 'package:curve/data/models/savedlocations.dart';
import 'package:curve/data/models/user.dart';
import '../../../presentation/view/view_model.dart';

@lazySingleton
class ProfileViewModel extends ViewModel {

  String? _userPhone;
  get userPhone => _userPhone;

  String? _userID;
  get userID => _userID;

  String? _profilePath;
  get profilePath => _profilePath;

  File? _profileFile;
  get profileFile => _profileFile;

  UserDetails? _userProfile = UserDetails();
  get userProfile => _userProfile;

  SavedLocationModel? _isHomeLocation;
  get isHomeLocation => _isHomeLocation;

  SavedLocationModel? _isWorkLocation;
  get isWorkLocation => _isWorkLocation;


  List<SavedLocationModel> _savedLocationList = [];
  get savedLocationList => _savedLocationList;

  PaymentMethods _userDefaultPayment = PaymentMethods();
  get userDefaultPayment => _userDefaultPayment;

  PaymentMethods _defaultPayHandle = PaymentMethods();
  get defaultPayHandle => _defaultPayHandle;




  Future getProfileDetails() async{

    _userID = await getSharedPrefManager.getPrefUserID();
    _userPhone = await getSharedPrefManager.getPrefUserPhone();
    _userProfile = await getSharedPrefManager.getPrefUserProfile();
    _savedLocationList = (await getSharedPrefManager.getPrefSavedLocations())!.cast<SavedLocationModel>();
    _userDefaultPayment = (await getSharedPrefManager.getPrefIsPrimaryMethod())!;

    print('#############DETAILES FETCHED');
    notifyListeners();

    await fetchSavedLocations();

    await getProfileFromCache();
  }




  Future navigateToSettings() async {
    await getNavigator.navigateTo(Routes.settingsView);
    print('Navigate to Settings');
  }

  Future getProfileFromCache() async{
    //_profilePath = await cacheManager.getFile(userProfile.originalImage);}
    _profilePath = null;
    notifyListeners();
    _profileFile = await findPath(userProfile.originalImage);
    notifyListeners();
  }

  Future findPath(String imageUrl) async {
    final cache =  cacheManager;
    final file = await cache.getSingleFile(imageUrl);

    //return file.path;

    File filed = new File(file.path);
    return filed;
  }

  Future navigateToEdit() async {
    /*
    await getNavigator.navigateTo(Routes.editProfileView).then((value) => () async{

      await getProfileFromCache();
      print('SHOULD WORK');
      await getProfileDetails();

      notifyListeners();
    });

     */

    bool result = await getNavigator.navigateTo(Routes.editProfileView,);
    if(result == null){
      await getProfileFromCache();
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }else if (result){
      await getProfileFromCache();
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }

    //print('Navigate to Edit');
  }

  Future navigateToPaymentOpt() async{

    print('Navigate to PayTrip');

    bool result = await getNavigator.navigateTo(Routes.paymentOptionView);
    if(result == null){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }else if (result){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }

  }

  Future navigateToRideHistory() async{

    print('Navigate to Ride History');

    bool result = await getNavigator.navigateTo(Routes.rideHistoryView);
    if(result == null){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }else if (result){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }

  }



  //SAVED LOCATIONS
  Future navigateToSavedLocation() async{

    print('Navigate to Saved Location');

    bool result = await getNavigator.navigateTo(Routes.locationOptionView);

    if(result == null){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }else if (result){
      await getProfileDetails();

      print('WORKS########################SSSSSSSSS');
      notifyListeners();
    }

  }

  Future navigateAddHomeWork({bool? isHome}) async{

    if(isHome!){
      print('Navigate to Add Location');

      bool result = await getNavigator.navigateTo(
          Routes.searchLocationView,
          arguments: SearchLocationViewArguments(
            isWork: false,
            isHome: true,
            isEditLocation: false,
          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Location saved successfully');
        notifyListeners();
      }
    } else{
      print('Navigate to Add Location');

      bool result = await getNavigator.navigateTo(
          Routes.searchLocationView,
          arguments: SearchLocationViewArguments(
            isWork: true,
            isHome: false,
            isEditLocation: false,
          )
      );
      if(result == null){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        notifyListeners();
      }else if(result){
        await fetchSavedLocations();
        print('WORKS########################SSSSSSSSS');

        showSnackBarGreenAlert('Location saved successfully');
        notifyListeners();
      }
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

  Future fetchSavedLocations()async{
    var savedLoc = await getSharedPrefManager.getPrefSavedLocations();
    _savedLocationList = savedLoc!.cast<SavedLocationModel>();
    notifyListeners();

    var indexPickH = savedLocationList.indexWhere((e) => e.tag == '####HOME');
    if(indexPickH > -1)
      {_isHomeLocation = savedLocationList[indexPickH];}
    else
      {_isHomeLocation = null;}

    var indexPickW = savedLocationList.indexWhere((e) => e.tag == '####WORK');
    if(indexPickW > -1)
      {_isWorkLocation = savedLocationList[indexPickW];}
    else
      {_isWorkLocation = null;}
    notifyListeners();
  }

  Future navigateToEditHomeWork ( {isHome})async{

   if(isHome){
     bool result = await getNavigator.navigateTo(Routes.editLocationView,
         arguments: EditLocationViewArguments(
           savedLocation: isHomeLocation,
           isHomeTag: true,
           isWorkTag: false,
         )
     );
     if(result == null){
       await fetchSavedLocations();
       print('WORKS########################SSSSSSSSS');

       notifyListeners();
     }else if(result){
       await fetchSavedLocations();
       print('WORKS########################SSSSSSSSS');

       showSnackBarGreenAlert('Saved location edited successfully');
       notifyListeners();
     }


   }else{
     bool result = await getNavigator.navigateTo(Routes.editLocationView,
         arguments: EditLocationViewArguments(
           savedLocation: isWorkLocation,
           isHomeTag: false,
           isWorkTag: true,
         )
     );
     if(result == null){
       await fetchSavedLocations();
       print('WORKS########################SSSSSSSSS');

       notifyListeners();
     }else if(result){
       await fetchSavedLocations();
       print('WORKS########################SSSSSSSSS');

       showSnackBarGreenAlert('Saved location edited successfully');
       notifyListeners();
     }


   }
  }


}