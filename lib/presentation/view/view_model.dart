import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



import '../../data/models/paymentmethods.dart';
import '../../app/app.router.dart';
import '../../data/data_repository/repositories_impl/bus_trip_repository_impl.dart';
import '../../data/data_repository/repositories_impl/trip_repository_impl.dart';
import '../../services/third_party_services/notification_service.dart';
import '../../services/third_party_services/location_service.dart';
import '../../services/third_party_services/toast_service.dart';
import '../../app/app.locator.dart';
import '../../services/third_party_services/connectivity_service.dart';
import '../../services/third_party_services/firebaseauth_service.dart';
import '../../services/third_party_services/media_service.dart';
import '../widgets/setup_bottomsheet_ui.dart';
import '../../enums/connectivity_status.dart';
import '../../presentation/widgets/setup_dialog_ui.dart';
import '../../presentation/widgets/setup_snackbar_ui.dart';
import '../../services/third_party_services/flushbar_services.dart';
import '../../data/data_sources/local/sharedpreference.dart';
import '../../utilities/internet_util.dart';
import '../../data/models/user.dart';
import '../../domain/repository/user_repository.dart';
import '../../data/data_repository/repositories_impl/user_repository_impl.dart';


abstract class ViewModel extends BaseViewModel {

  final ThemeService _themeService = locator<ThemeService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ToastService _toastService = locator<ToastService>();
  final DialogService _dialogService = locator<DialogService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final ConnectivityService _connectivityService = locator<ConnectivityService>();
  final SharedPrefManager _sharedPrefManager = locator<SharedPrefManager>();
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  final MediaService _mediaService = locator<MediaService>();
  final LocationService _locationService = locator<LocationService>();
  final NotificationService _notificationService = locator<NotificationService>();
  final UserRepositoryImpl _userRepositoryImpl = locator<UserRepositoryImpl>();
  final TripRepositoryImpl _tripRepositoryImpl = locator<TripRepositoryImpl>();
  final BusTripRepositoryImpl _busTripRepositoryImpl = locator<BusTripRepositoryImpl>();
  DefaultCacheManager cacheManager =  DefaultCacheManager();
  final _getContext = Get.context!;

  ThemeService get getTheme => _themeService;
  NavigationService get getNavigator => _navigationService;
  DialogService get getDialogService => _dialogService;
  ToastService get getToastService => _toastService;
  SnackbarService get getSnackBar => _snackbarService;
  BottomSheetService get getBottomSheet => _bottomSheetService;
  ConnectivityService get getConnectivity => _connectivityService;
  SharedPrefManager get getSharedPrefManager => _sharedPrefManager;
  FirebaseAuthService get getFirebaseAuthService => _firebaseAuthService;
  MediaService get getMediaService => _mediaService;
  NotificationService get getNotificationService => _notificationService;
  LocationService get getLocationService => _locationService;
  UserRepositoryImpl get getUserRepositoryImpl => _userRepositoryImpl;
  TripRepositoryImpl get getTripRepositoryImpl => _tripRepositoryImpl;
  BusTripRepositoryImpl get getBusTripRepositoryImpl => _busTripRepositoryImpl;

  Map<String, dynamic> _payloadData = Map();
  get payloadData => _payloadData;





  Future<bool> internetCheckWithLoading() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
      await dismissLoadingDialog();

      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: AppLocalizations.of(_getContext)!.looksLikeYoureOffline,
      );
      return Future.value(false);
    }else {
      return Future.value(true);
    }

    /*
    if (await InternetUtil.isConnected()) {
      return Future.value(true);
    } else {
      await dismissLoadingDialog();

      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: "Looks like you're offline. Make sure you're connected to the internet",
      );
      return Future.value(false);
    }

     */
  }

  Future<bool> internetCheckWithOutLoading() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){

      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: AppLocalizations.of(_getContext)!.looksLikeYoureOffline,
      );
      return Future.value(false);
    }else {
      return Future.value(true);
    }

    /*
    if (await InternetUtil.isConnected()) {
      return Future.value(true);
    } else {
      await dismissLoadingDialog();

      getSnackBar.showCustomSnackBar(
        variant: SnackbarType.redAlert,
        duration: Duration(seconds: 3),
        message: "Looks like you're offline. Make sure you're connected to the internet",
      );
      return Future.value(false);
    }

     */
  }

  Future showSnackBarRedAlert( String message) async{
    getSnackBar.showCustomSnackBar(
      variant: SnackbarType.redAlert,
      duration: Duration(seconds: 3),
      message: message,

    );
  }

  Future showSnackBarGreyAlert( String message) async{
    getSnackBar.showCustomSnackBar(
      variant: SnackbarType.greyAlert,
      duration: Duration(seconds: 3),
      message: message,
    );
  }

  Future showSnackBarGreenAlert( String message) async{
    getSnackBar.showCustomSnackBar(
      variant: SnackbarType.greenAlert,
      duration: Duration(seconds: 3),
      message: message,
    );
  }

  Future showSnackBarGreenInternetAlert( ) async{
    getSnackBar.showCustomSnackBar(
      variant: SnackbarType.greenInternet,
      duration: Duration(seconds: 15),
      message: AppLocalizations.of(_getContext)!.youConnected,
      //message: 'Please check your internet connection',
    );
  }

  Future showSnackBarRedInternetAlert( ) async{
    getSnackBar.showCustomSnackBar(
      variant: SnackbarType.redInternet,
      duration: Duration(seconds: 15),
      message: AppLocalizations.of(_getContext)!.noInternet,
      //message: '',
    );
  }

  /*
  void showFlushBar(BuildContext context) async{
    getFlushBarService.flushBarMessages(
      message: 'Ride Cancelled',
      color: Colors.green,
    )..show(context);
  }

   */

  void themeSwapCode(BuildContext context){
    //Getting Theme Data
    //var theme = Theme.of(context);

    getTheme.setThemeMode(ThemeManagerMode.dark);


    //Set theme to second theme in getThemes()
    getThemeManager(context).selectThemeAtIndex(1);

    //Toggles Theme
    getThemeManager(context).toggleDarkLightTheme();

    //Sets Theme Mode
    getThemeManager(context).setThemeMode(ThemeMode.light);

    //Get currently selected theme
    getThemeManager(context).selectedThemeIndex;

    //Get selected Theme Mode
    getThemeManager(context).selectedThemeMode;

  }

  Future showLoadingDialog(String status, bool dissmisable) async {
    await getDialogService.showCustomDialog(
      barrierDismissible: dissmisable,
      variant: DialogType.loading, // Which builder you'd like to call that was assigned in the builders function above.
      title: status,
    );
  }

  Future<bool> dismissLoadingDialog() {
    getNavigator.back();
    // Navigator.of(_context, rootNavigator: false).pop();
    // print("Removing dialog....");
    return Future.value(true);
  }

  Future<bool> showDialogFailed({String? title, String? description, String? mainTitle, String? secondTitle}) async {
    var response =   await _dialogService.showCustomDialog(
      variant: DialogType.onFailed, // Which builder you'd like to call that was assigned in the builders function above.
      title: title,
      description: description,
      mainButtonTitle: mainTitle,
      secondaryButtonTitle: secondTitle,
    );

    //response.confirm = true means main button clicked
    if(response!.confirmed) {
      return true;
    }else return false;

  }

  Future<bool>  showDialogBasic({String? title, String? description, String? mainTitle, String? secondTitle}) async {
    var response =   await _dialogService.showCustomDialog(
      variant: DialogType.basic, // Which builder you'd like to call that was assigned in the builders function above.
      title: title,
      description: description,
      mainButtonTitle: mainTitle,
      secondaryButtonTitle: secondTitle,
    );

    //response.confirm = true means main button clicked
    if(response!.confirmed) {
      return true;
    }else return false;

  }

  Future<bool> showDialogConfirm({String? title, String? description, String? mainTitle, String? secondTitle}) async {
    var response =   await _dialogService.showCustomDialog(
      variant: DialogType.basic, // Which builder you'd like to call that was assigned in the builders function above.
      title: title,
      description: description,
      mainButtonTitle: mainTitle,
      secondaryButtonTitle: secondTitle,
    );

    //response.confirm = true means main button clicked
    if(response!.confirmed) {
      return true;
    }else return false;

  }

  Future<bool> showDialogConfirmRed({String? title, String? description, String? mainTitle, String? secondTitle}) async {
    var response =   await _dialogService.showCustomDialog(
      variant: DialogType.onConfirmRed, // Which builder you'd like to call that was assigned in the builders function above.
      title: title,
      description: description,
      mainButtonTitle: mainTitle,
      secondaryButtonTitle: secondTitle,
    );

    //response.confirm = true means main button clicked
    if(response!.confirmed) {
      return true;
    }else return false;

  }

  Future<bool> showNoDriver({String? title, String? description, String? mainTitle, String? secondTitle}) async {
    var response =   await _dialogService.showCustomDialog(
      variant: DialogType.onNoDriver,
      title: AppLocalizations.of(_getContext)!.noDriversAvailable,
      description: AppLocalizations.of(_getContext)!.weCouldntFindAnyDriver,
      mainButtonTitle: AppLocalizations.of(_getContext)!.cancel,

      // Which builder you'd like to call that was assigned in the builders function above.
    );

    //response.confirm = true means main button clicked
    if(response!.confirmed) {
      return true;
    }else return false;

  }

  Future<bool> showBusNotStarted({String? title, String? description, String? mainTitle, String? secondTitle}) async {
    var response =   await _dialogService.showCustomDialog(
      variant: DialogType.onNoDriver,
      title: AppLocalizations.of(_getContext)!.busHasNotYetStarted,
      description: AppLocalizations.of(_getContext)!.busHasNotStarted,
      mainButtonTitle: AppLocalizations.of(_getContext)!.close,
      // Which builder you'd like to call that was assigned in the builders function above.
    );

    //response.confirm = true means main button clicked
    if(response!.confirmed) {
      return true;
    }else return false;

  }

  Future<bool> showDriverArrived({customData}) async {
    var response =   await _dialogService.showCustomDialog(
      variant: DialogType.onDriverArrived,
      data: customData,// Which builder you'd like to call that was assigned in the builders function above.
    );

    //response.confirm = true means main button clicked
    if(response!.confirmed) {
      return true;
    }else return false;

  }



  //TEST CODES
  Future showConfirmationDialog() async {
    var response = await _dialogService.showConfirmationDialog(
      title: 'The Confirmation Dialog',
      description: 'Do you want to update Confirmation state in the UI?',
      confirmationTitle: 'Yes',
      dialogPlatform: DialogPlatform.Material,
      cancelTitle: 'No',
    );

    var  _confirmationResult= response!.confirmed;

    if(_confirmationResult) {
      // Do some confirmation action here.
    }

    notifyListeners();
  }

  Future showCustomDialog() async {
    var response =   await _dialogService.showCustomDialog(
      variant: DialogType.basic, // Which builder you'd like to call that was assigned in the builders function above.
      title: 'This is a custom UI with Text as main button',
      description: 'Sheck out the builder in the dialog_ui_register.dart file',
      mainButtonTitle: 'Ok',
    );

    //response.confirm = true means main button clicked

    if(response!.confirmed) {
      // Do some confirmation action here.
      print('TRUE WORKS');
    }

  }

  Future showBottomSheet() async{
    await getBottomSheet.showBottomSheet(
      title: 'Confirm this action with one of the options below',
      description: 'The result from this call will return a SheetResponse object with confirmed set to true. See the logs where we print out the confirmed value for you.',
      confirmButtonTitle: 'I confirm',
      cancelButtonTitle: 'I DONT confirm',
    );
  }

  Future showCustomBottomSheet () async{
    var confirmationResponse =
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.basic,
      title: 'This is a floating bottom sheet',
      description:
      'This sheet is a custom built bottom sheet UI that allows you to show it from any service or viewmodel.',
      mainButtonTitle: 'Awesome!',
      secondaryButtonTitle: 'This is cool',
    );
    print( 'confirmationResponse confirmed: ${confirmationResponse?.confirmed}');
  }


  Stream<int> get stream => epochUpdatesNumbers();

  Stream<int> epochUpdatesNumbers() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      yield DateTime.now().millisecondsSinceEpoch;
    }
  }

  StreamSubscription<ConnectivityStatus> get connectivityStatus => getConnectivity.connectionStatusController.stream.listen((event) async{
    switch(event) {
      case ConnectivityStatus.Cellular: {
        // statements;
        print('CONNECTED TO MOBILE');
        if(getSnackBar.isSnackbarOpen!){
          //scaffoldKey.currentState.hideCurrentSnackBar();
        }
        showSnackBarGreenInternetAlert();
        //return ConnectivityStatus.Cellular;
      }
      break;

      case ConnectivityStatus.WiFi: {
        print('CONNECTED TO WIFI');
        showSnackBarGreenInternetAlert();
      }
      break;

      case ConnectivityStatus.Offline: {
        print('LOST CONNECTION');
        showSnackBarRedInternetAlert();
      }
      break;

      default: {
        //statements;
      }
      break;
    }
  });








  checkLoginStatus(UserRepository _userRepository) async {

    final isConnected = await InternetUtil.isConnected();

    if (isConnected) {
      print("Checking user status");

      UserDetails? userDetailsShared;
      UserDetails? userDetailsRemote;

      userDetailsShared = await _userRepository.getUserProfile(fromRemote: false);

      if (userDetailsShared == null){
        userDetailsRemote = await _userRepository.getUserProfile(fromRemote: true);
      }

      var page = "";
      if (userDetailsShared == null && userDetailsRemote == null) {
        page = Routes.createProfileView;
      } else {

        await getAllUserData();
        getSharedPrefManager.hasLoggedIn = true;
        //BUS CHANGE
        //page = Routes.bottomNavBarView;
        page = Routes.busHomeView;
      }

      getNavigator.clearStackAndShow(page);
    } else {
      //getNavigator.clearStackAndShow(Routes.driverMainView);
      return;
    }
  }

  loginLogic(UserRepository _userRepository) async {

      final isLoggedIn = getSharedPrefManager.hasLoggedIn;
      UserDetails? userDetailsShared;

      userDetailsShared = await _userRepository.getUserProfile(fromRemote: false);

      var page = "";

      if (userDetailsShared == null && isLoggedIn == false) {
        page = Routes.getStartedView;
      } else {
        //BUS CHANGE
        //page = Routes.bottomNavBarView;
        page = Routes.busHomeView;
      }
      getNavigator.clearStackAndShow(page);
  }

  Future getAllUserData()async{
    await getUserRepositoryImpl.getPaymentMethods(fromRemote: true);
    await getUserRepositoryImpl.getRideHistory(fromRemote: true);
    await getUserRepositoryImpl.getSavedLocation(fromRemote: true);
    await getBusTripRepositoryImpl.getAllTickets(fromRemote: true);

    var paymentData = await getSharedPrefManager.getPrefPaymentMethods();

    if(paymentData != null){
      List<PaymentMethods> paymentMethodsList = [];
      paymentMethodsList = paymentData.cast<PaymentMethods>();

      int indexPick = paymentMethodsList.indexWhere((e) => e.isPrimary == true);
      var isPrimaryPayment = paymentMethodsList[indexPick];

      getSharedPrefManager.setPrefIsPrimaryMethod(isPrimaryPayment);
    }

  }

  /*
  CHANGES FOR BUS
  Future navigateToHome() async {
    await getNavigator.navigateTo(Routes.bottomNavBarView);
    print('Navigate to home');
  }

   */

  Future navigateToHome() async {
    await getNavigator.navigateTo(Routes.busHomeView);
    print('Navigate to home');
  }
}