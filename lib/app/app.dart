


import 'package:curve/presentation/view/ride/on_demand_ride/on_demand_ride_view.dart';
import 'package:curve/presentation/view/ride/search_ride/available_bus_routes/available_bus_routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';



import '../presentation/view/bus/tickets/showticket/show_ticket_view.dart';
import '../presentation/view/bus/bus_ride_trip/bus_ride_trip_view.dart';
import '../presentation/view/bus/bus_home/bus_home_view.dart';
import '../presentation/view/locations/search_location/searchlocation_view.dart';
import '../presentation/view/home_navbar/bottom_navbar/bottom_navbar_view.dart';
import '../presentation/view/payment/pay/pay_view.dart';
import '../presentation/view/profile/profile_view.dart';
import '../presentation/view/home_navbar/stackedbottom_navbar/stackedbottom_view.dart';
import '../presentation/view/profile/edit_profile/editprofile_view.dart';
import '../presentation/view/bus/bus/bus_view.dart';
import '../presentation/view/ride/ride_view.dart';
import '../presentation/view/onboard/splashscreen/splashscreen_view.dart';
import '../presentation/view/onboard/getstarted/getstarted_view.dart';
import '../presentation/view/onboard/login/otpscreen_view.dart';
import '../presentation/view/onboard/login/login_view.dart';
import '../presentation/view/onboard/createprofile/createprofile_view.dart';
import '../presentation/view/payment/edit_payment/payment_edit_view.dart';
import '../presentation/view/payment/add_payment/payment_add_view.dart';
import '../presentation/view/payment/payment_opt_view.dart';
import '../presentation/view/bus/bustripdetails/bustripdetails_view.dart';
import '../presentation/view/bus/confirmbus/confirmbus_view.dart';
import '../presentation/view/bus/tickets/ticket_view.dart';
import '../presentation/view/bus/tickets/all_tickets/all_ticket_view.dart';
import '../presentation/view/bus/tickets/booked_ticket/booked_ticket_view.dart';
import '../presentation/view/bus/payticket/payticket_view.dart';
import '../presentation/view/locations/location_add/location_add_view.dart';
import '../presentation/view/locations/location_edit/location_edit_view.dart';
import '../presentation/view/locations/location_opt/location_opt_view.dart';
import '../presentation/view/profile/history/ride_history_view.dart';
import '../presentation/view/settings/settings_view.dart';
import '../presentation/view/ride/rate/rate_view.dart';
import '../presentation/view/ride/search_ride/searchride_view.dart';
import '../presentation/view/ride/addnote/addnote_view.dart';
import '../presentation/view/ride/cancelride/cancelride_view.dart';




import '../services/third_party_services/connectivity_service.dart';
import '/services/third_party_services/toast_service.dart';
import '/services/third_party_services/flushbar_services.dart';
import '/services/third_party_services/firebaseauth_service.dart';
import '/services/third_party_services/media_service.dart';
import '/services/third_party_services/notification_service.dart';
import '/services/third_party_services/location_service.dart';

import '../data/data_sources/local/sharedpreference.dart';
import '../data/data_repository/repositories_impl/user_repository_impl.dart';
import '../data/data_repository/repositories_impl/trip_repository_impl.dart';
import '../data/data_repository/repositories_impl/bus_trip_repository_impl.dart';
import '../data/data_sources/remote/api_impl.dart';


@StackedApp(
  routes: [
    // initial route is named "/"
    CustomRoute(page: SplashScreenView, initial: true,transitionsBuilder: TransitionsBuilders.fadeIn),

    CustomRoute<bool>(page: StackedBottomNavView,transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute<bool>(page: BottomNavBarView,transitionsBuilder: TransitionsBuilders.fadeIn),

    CustomRoute<bool>(page: BusHomeView,transitionsBuilder: TransitionsBuilders.fadeIn),


    //ONBOARD
    CustomRoute(page: GetStartedView,transitionsBuilder: TransitionsBuilders.fadeIn),
    CupertinoRoute<bool>(page: LoginView,),
    CupertinoRoute<bool>(page: OTPScreenView,),
    CupertinoRoute<bool>(page: CreateProfileView,),

    //BUS
    CupertinoRoute<bool>(page: BusView,),
    CupertinoRoute<bool>(page: BusTripDetailsView,),
    CupertinoRoute<bool>(page: ConfirmBusView,),
    CupertinoRoute<bool>(page: TicketView,),
    CupertinoRoute<bool>(page: AllTicketView,),
    CupertinoRoute<bool>(page: BookedTicketView,),
    CupertinoRoute<bool>(page: ShowTicketView,),
    CupertinoRoute<bool>(page: PayTicketView,),
    CustomRoute<bool>(page: BusRideView,transitionsBuilder: TransitionsBuilders.fadeIn),

    //RIDE
    CupertinoRoute<bool>(page: RideView,),
    MaterialRoute<bool>(page: OnDemandRideView,),
    MaterialRoute<bool>(page: SearchRideView, ),
    CupertinoRoute<bool>(page: AvailableBusRoutesView,),
    CupertinoRoute<bool>(page: RateView,),
    CustomRoute<bool>(page: AddNoteView,transitionsBuilder: TransitionsBuilders.slideBottom),
    CustomRoute<bool>(page: CancelRideView,transitionsBuilder: TransitionsBuilders.slideBottom),


    //PROFILE
    CupertinoRoute<bool>(page: ProfileView,),
    CupertinoRoute<bool>(page: EditProfileView,),
    CupertinoRoute<bool>(page: RideHistoryView,),

    CustomRoute<bool>(page: SettingsView,transitionsBuilder: TransitionsBuilders.slideBottom),

    //PAYMENT
    CupertinoRoute<bool>(page: EditPaymentView,),
    CupertinoRoute<bool>(page: PaymentOptionView,),
    CupertinoRoute<bool>(page: AddPaymentView,),
    CupertinoRoute<bool>(page: PayView,),

    //LOCATION
    CupertinoRoute<bool>(page: AddLocationView,),
    CupertinoRoute<bool>(page: LocationOptionView,),
    CupertinoRoute<bool>(page: EditLocationView,),
    CupertinoRoute<bool>(page: SearchLocationView,),


    /*
    MaterialRoute(page: ProfileNavigator, children: [
      MaterialRoute(page: ProfileView, initial: true),
    ]),
     */

  ],




  dependencies: [

    // Lazy singletons
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SharedPrefManager),
    LazySingleton(
      classType: ThemeService,
      resolveUsing: ThemeService.getInstance,
    ),

    LazySingleton(classType: ToastService),
    LazySingleton(classType: ConnectivityService),
    LazySingleton(classType: UserRepositoryImpl),
    LazySingleton(classType: TripRepositoryImpl),
    LazySingleton(classType: BusTripRepositoryImpl),
    LazySingleton(classType: ApiImpl),
    LazySingleton(classType: FirebaseAuthService),
    LazySingleton(classType: MediaService),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: LocationService),

    // LazySingleton(
    //   classType: InformationService,
    //   dispose: disposeInformationService,
    // ),
    //LazySingleton(classType: NavigationService, environments: {Environment.dev}),
    //Presolve(
    //classType: SharedPrefManager,
    //presolveUsing: SharedPrefManager.,
    //),
    //LazySingleton(classType: InformationService),
    //FactoryWithParam(classType: FactoryService),
    // singletons
    //Singleton(classType: HistoryViewModel),
    //Singleton(classType: FavoritesViewModel),
  ],
  //logger: StackedLogger(),
  locatorName: 'locator',
  locatorSetupName: 'setupLocator',
)

class $AppRouter {}