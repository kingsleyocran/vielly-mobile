
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'third_party_services/connectivity_service.dart';
import 'third_party_services/toast_service.dart';
import 'third_party_services/firebaseauth_service.dart';
import 'third_party_services/media_service.dart';
import 'third_party_services/notification_service.dart';
import 'third_party_services/location_service.dart';

import '../data/data_sources/local/sharedpreference.dart';
import '../data/data_repository/repositories_impl/user_repository_impl.dart';
import '../data/data_repository/repositories_impl/trip_repository_impl.dart';
import '../data/data_repository/repositories_impl/bus_trip_repository_impl.dart';
import '../data/data_sources/remote/api_impl.dart';

@module
abstract class ThirdPartyServicesModule {

  @lazySingleton
  NavigationService get navigationService;

  @lazySingleton
  DialogService get dialogService;

  @lazySingleton
  BottomSheetService get bottomSheetService;

  @lazySingleton
  ToastService get toastService;

  @lazySingleton
  SnackbarService get snackbarService;

  @lazySingleton
  ConnectivityService get connectivityService;

  @lazySingleton
  ThemeService get themeService;

  @lazySingleton
  SharedPrefManager get preferenceService;

  @lazySingleton
  UserRepositoryImpl get userRepository;

  @lazySingleton
  TripRepositoryImpl get tripRepository;

  @lazySingleton
  BusTripRepositoryImpl get busTripRepository;

  @lazySingleton
  ApiImpl get apiService;

  @lazySingleton
  FirebaseAuthService get firebaseAuthService;

  @lazySingleton
  MediaService get mediaService;

  @lazySingleton
  NotificationService get notificationService;

  @lazySingleton
  LocationService get locationService;
}