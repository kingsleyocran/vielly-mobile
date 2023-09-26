// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../data/data_repository/repositories_impl/bus_trip_repository_impl.dart';
import '../data/data_repository/repositories_impl/trip_repository_impl.dart';
import '../data/data_repository/repositories_impl/user_repository_impl.dart';
import '../data/data_sources/local/sharedpreference.dart';
import '../data/data_sources/remote/api_impl.dart';
import '../services/third_party_services/connectivity_service.dart';
import '../services/third_party_services/firebaseauth_service.dart';
import '../services/third_party_services/location_service.dart';
import '../services/third_party_services/media_service.dart';
import '../services/third_party_services/notification_service.dart';
import '../services/third_party_services/toast_service.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SharedPrefManager());
  locator.registerLazySingleton(() => ThemeService.getInstance());
  locator.registerLazySingleton(() => ToastService());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => UserRepositoryImpl());
  locator.registerLazySingleton(() => TripRepositoryImpl());
  locator.registerLazySingleton(() => BusTripRepositoryImpl());
  locator.registerLazySingleton(() => ApiImpl());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => MediaService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => LocationService());
}
