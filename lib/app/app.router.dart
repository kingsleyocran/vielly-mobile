// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../data/models/address.dart';
import '../data/models/busschedule_data.dart';
import '../data/models/paymentmethods.dart';
import '../data/models/savedlocations.dart';
import '../data/models/ticket.dart';
import '../presentation/view/bus/bus/bus_view.dart';
import '../presentation/view/bus/bus_home/bus_home_view.dart';
import '../presentation/view/bus/bus_ride_trip/bus_ride_trip_view.dart';
import '../presentation/view/bus/bustripdetails/bustripdetails_view.dart';
import '../presentation/view/bus/confirmbus/confirmbus_view.dart';
import '../presentation/view/bus/payticket/payticket_view.dart';
import '../presentation/view/bus/tickets/all_tickets/all_ticket_view.dart';
import '../presentation/view/bus/tickets/booked_ticket/booked_ticket_view.dart';
import '../presentation/view/bus/tickets/showticket/show_ticket_view.dart';
import '../presentation/view/bus/tickets/ticket_view.dart';
import '../presentation/view/home_navbar/bottom_navbar/bottom_navbar_view.dart';
import '../presentation/view/home_navbar/stackedbottom_navbar/stackedbottom_view.dart';
import '../presentation/view/locations/location_add/location_add_view.dart';
import '../presentation/view/locations/location_edit/location_edit_view.dart';
import '../presentation/view/locations/location_opt/location_opt_view.dart';
import '../presentation/view/locations/search_location/searchlocation_view.dart';
import '../presentation/view/onboard/createprofile/createprofile_view.dart';
import '../presentation/view/onboard/getstarted/getstarted_view.dart';
import '../presentation/view/onboard/login/login_view.dart';
import '../presentation/view/onboard/login/otpscreen_view.dart';
import '../presentation/view/onboard/splashscreen/splashscreen_view.dart';
import '../presentation/view/payment/add_payment/payment_add_view.dart';
import '../presentation/view/payment/edit_payment/payment_edit_view.dart';
import '../presentation/view/payment/pay/pay_view.dart';
import '../presentation/view/payment/payment_opt_view.dart';
import '../presentation/view/profile/edit_profile/editprofile_view.dart';
import '../presentation/view/profile/history/ride_history_view.dart';
import '../presentation/view/profile/profile_view.dart';
import '../presentation/view/ride/addnote/addnote_view.dart';
import '../presentation/view/ride/cancelride/cancelride_view.dart';
import '../presentation/view/ride/on_demand_ride/on_demand_ride_view.dart';
import '../presentation/view/ride/rate/rate_view.dart';
import '../presentation/view/ride/ride_view.dart';
import '../presentation/view/ride/search_ride/available_bus_routes/available_bus_routes.dart';
import '../presentation/view/ride/search_ride/searchride_view.dart';
import '../presentation/view/settings/settings_view.dart';

class Routes {
  static const String splashScreenView = '/';
  static const String stackedBottomNavView = '/stacked-bottom-nav-view';
  static const String bottomNavBarView = '/bottom-nav-bar-view';
  static const String busHomeView = '/bus-home-view';
  static const String getStartedView = '/get-started-view';
  static const String loginView = '/login-view';
  static const String oTPScreenView = '/o-tp-screen-view';
  static const String createProfileView = '/create-profile-view';
  static const String busView = '/bus-view';
  static const String busTripDetailsView = '/bus-trip-details-view';
  static const String confirmBusView = '/confirm-bus-view';
  static const String ticketView = '/ticket-view';
  static const String allTicketView = '/all-ticket-view';
  static const String bookedTicketView = '/booked-ticket-view';
  static const String showTicketView = '/show-ticket-view';
  static const String payTicketView = '/pay-ticket-view';
  static const String busRideView = '/bus-ride-view';
  static const String rideView = '/ride-view';
  static const String onDemandRideView = '/on-demand-ride-view';
  static const String searchRideView = '/search-ride-view';
  static const String availableBusRoutesView = '/available-bus-routes-view';
  static const String rateView = '/rate-view';
  static const String addNoteView = '/add-note-view';
  static const String cancelRideView = '/cancel-ride-view';
  static const String profileView = '/profile-view';
  static const String editProfileView = '/edit-profile-view';
  static const String rideHistoryView = '/ride-history-view';
  static const String settingsView = '/settings-view';
  static const String editPaymentView = '/edit-payment-view';
  static const String paymentOptionView = '/payment-option-view';
  static const String addPaymentView = '/add-payment-view';
  static const String payView = '/pay-view';
  static const String addLocationView = '/add-location-view';
  static const String locationOptionView = '/location-option-view';
  static const String editLocationView = '/edit-location-view';
  static const String searchLocationView = '/search-location-view';
  static const all = <String>{
    splashScreenView,
    stackedBottomNavView,
    bottomNavBarView,
    busHomeView,
    getStartedView,
    loginView,
    oTPScreenView,
    createProfileView,
    busView,
    busTripDetailsView,
    confirmBusView,
    ticketView,
    allTicketView,
    bookedTicketView,
    showTicketView,
    payTicketView,
    busRideView,
    rideView,
    onDemandRideView,
    searchRideView,
    availableBusRoutesView,
    rateView,
    addNoteView,
    cancelRideView,
    profileView,
    editProfileView,
    rideHistoryView,
    settingsView,
    editPaymentView,
    paymentOptionView,
    addPaymentView,
    payView,
    addLocationView,
    locationOptionView,
    editLocationView,
    searchLocationView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashScreenView, page: SplashScreenView),
    RouteDef(Routes.stackedBottomNavView, page: StackedBottomNavView),
    RouteDef(Routes.bottomNavBarView, page: BottomNavBarView),
    RouteDef(Routes.busHomeView, page: BusHomeView),
    RouteDef(Routes.getStartedView, page: GetStartedView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.oTPScreenView, page: OTPScreenView),
    RouteDef(Routes.createProfileView, page: CreateProfileView),
    RouteDef(Routes.busView, page: BusView),
    RouteDef(Routes.busTripDetailsView, page: BusTripDetailsView),
    RouteDef(Routes.confirmBusView, page: ConfirmBusView),
    RouteDef(Routes.ticketView, page: TicketView),
    RouteDef(Routes.allTicketView, page: AllTicketView),
    RouteDef(Routes.bookedTicketView, page: BookedTicketView),
    RouteDef(Routes.showTicketView, page: ShowTicketView),
    RouteDef(Routes.payTicketView, page: PayTicketView),
    RouteDef(Routes.busRideView, page: BusRideView),
    RouteDef(Routes.rideView, page: RideView),
    RouteDef(Routes.onDemandRideView, page: OnDemandRideView),
    RouteDef(Routes.searchRideView, page: SearchRideView),
    RouteDef(Routes.availableBusRoutesView, page: AvailableBusRoutesView),
    RouteDef(Routes.rateView, page: RateView),
    RouteDef(Routes.addNoteView, page: AddNoteView),
    RouteDef(Routes.cancelRideView, page: CancelRideView),
    RouteDef(Routes.profileView, page: ProfileView),
    RouteDef(Routes.editProfileView, page: EditProfileView),
    RouteDef(Routes.rideHistoryView, page: RideHistoryView),
    RouteDef(Routes.settingsView, page: SettingsView),
    RouteDef(Routes.editPaymentView, page: EditPaymentView),
    RouteDef(Routes.paymentOptionView, page: PaymentOptionView),
    RouteDef(Routes.addPaymentView, page: AddPaymentView),
    RouteDef(Routes.payView, page: PayView),
    RouteDef(Routes.addLocationView, page: AddLocationView),
    RouteDef(Routes.locationOptionView, page: LocationOptionView),
    RouteDef(Routes.editLocationView, page: EditLocationView),
    RouteDef(Routes.searchLocationView, page: SearchLocationView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    SplashScreenView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SplashScreenView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
    StackedBottomNavView: (data) {
      return PageRouteBuilder<bool>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StackedBottomNavView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
    BottomNavBarView: (data) {
      return PageRouteBuilder<bool>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BottomNavBarView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
    BusHomeView: (data) {
      return PageRouteBuilder<bool>(
        pageBuilder: (context, animation, secondaryAnimation) => BusHomeView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
    GetStartedView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GetStartedView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
    LoginView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => LoginView(),
        settings: data,
      );
    },
    OTPScreenView: (data) {
      var args = data.getArgs<OTPScreenViewArguments>(nullOk: false);
      return CupertinoPageRoute<bool>(
        builder: (context) => OTPScreenView(
          key: args.key,
          mobileNumber: args.mobileNumber,
        ),
        settings: data,
      );
    },
    CreateProfileView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => CreateProfileView(),
        settings: data,
      );
    },
    BusView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => BusView(),
        settings: data,
      );
    },
    BusTripDetailsView: (data) {
      var args = data.getArgs<BusTripDetailsViewArguments>(
        orElse: () => BusTripDetailsViewArguments(),
      );
      return CupertinoPageRoute<bool>(
        builder: (context) => BusTripDetailsView(
          key: args.key,
          schedule: args.schedule,
          busSchedule: args.busSchedule,
          busScheduleList: args.busScheduleList,
        ),
        settings: data,
      );
    },
    ConfirmBusView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => ConfirmBusView(),
        settings: data,
      );
    },
    TicketView: (data) {
      var args = data.getArgs<TicketViewArguments>(nullOk: false);
      return CupertinoPageRoute<bool>(
        builder: (context) => TicketView(
          key: args.key,
          ticketDetails: args.ticketDetails,
        ),
        settings: data,
      );
    },
    AllTicketView: (data) {
      var args = data.getArgs<AllTicketViewArguments>(
        orElse: () => AllTicketViewArguments(),
      );
      return CupertinoPageRoute<bool>(
        builder: (context) => AllTicketView(
          key: args.key,
          ticketDetails: args.ticketDetails,
        ),
        settings: data,
      );
    },
    BookedTicketView: (data) {
      var args = data.getArgs<BookedTicketViewArguments>(nullOk: false);
      return CupertinoPageRoute<bool>(
        builder: (context) => BookedTicketView(
          key: args.key,
          ticketDetails: args.ticketDetails,
        ),
        settings: data,
      );
    },
    ShowTicketView: (data) {
      var args = data.getArgs<ShowTicketViewArguments>(nullOk: false);
      return CupertinoPageRoute<bool>(
        builder: (context) => ShowTicketView(
          key: args.key,
          ticketDetails: args.ticketDetails,
        ),
        settings: data,
      );
    },
    PayTicketView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => PayTicketView(),
        settings: data,
      );
    },
    BusRideView: (data) {
      var args = data.getArgs<BusRideViewArguments>(
        orElse: () => BusRideViewArguments(),
      );
      return PageRouteBuilder<bool>(
        pageBuilder: (context, animation, secondaryAnimation) => BusRideView(
          key: args.key,
          ticketDetails: args.ticketDetails,
        ),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
    RideView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => RideView(),
        settings: data,
      );
    },
    OnDemandRideView: (data) {
      return MaterialPageRoute<bool>(
        builder: (context) => OnDemandRideView(),
        settings: data,
      );
    },
    SearchRideView: (data) {
      var args = data.getArgs<SearchRideViewArguments>(
        orElse: () => SearchRideViewArguments(),
      );
      return MaterialPageRoute<bool>(
        builder: (context) => SearchRideView(
          onDestinationSelected: args.onDestinationSelected,
          key: args.key,
        ),
        settings: data,
      );
    },
    AvailableBusRoutesView: (data) {
      var args = data.getArgs<AvailableBusRoutesViewArguments>(
        orElse: () => AvailableBusRoutesViewArguments(),
      );
      return CupertinoPageRoute<bool>(
        builder: (context) => AvailableBusRoutesView(
          key: args.key,
          ticketDetails: args.ticketDetails,
        ),
        settings: data,
      );
    },
    RateView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => RateView(),
        settings: data,
      );
    },
    AddNoteView: (data) {
      return PageRouteBuilder<bool>(
        pageBuilder: (context, animation, secondaryAnimation) => AddNoteView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.slideBottom,
      );
    },
    CancelRideView: (data) {
      return PageRouteBuilder<bool>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CancelRideView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.slideBottom,
      );
    },
    ProfileView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => ProfileView(),
        settings: data,
      );
    },
    EditProfileView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => EditProfileView(),
        settings: data,
      );
    },
    RideHistoryView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => const RideHistoryView(),
        settings: data,
      );
    },
    SettingsView: (data) {
      return PageRouteBuilder<bool>(
        pageBuilder: (context, animation, secondaryAnimation) => SettingsView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.slideBottom,
      );
    },
    EditPaymentView: (data) {
      var args = data.getArgs<EditPaymentViewArguments>(nullOk: false);
      return CupertinoPageRoute<bool>(
        builder: (context) => EditPaymentView(
          key: args.key,
          paymentMethods: args.paymentMethods,
        ),
        settings: data,
      );
    },
    PaymentOptionView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => const PaymentOptionView(),
        settings: data,
      );
    },
    AddPaymentView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => const AddPaymentView(),
        settings: data,
      );
    },
    PayView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => PayView(),
        settings: data,
      );
    },
    AddLocationView: (data) {
      var args = data.getArgs<AddLocationViewArguments>(nullOk: false);
      return CupertinoPageRoute<bool>(
        builder: (context) => AddLocationView(
          key: args.key,
          isHomeTag: args.isHomeTag,
          isWorkTag: args.isWorkTag,
          savedAddress: args.savedAddress,
        ),
        settings: data,
      );
    },
    LocationOptionView: (data) {
      return CupertinoPageRoute<bool>(
        builder: (context) => const LocationOptionView(),
        settings: data,
      );
    },
    EditLocationView: (data) {
      var args = data.getArgs<EditLocationViewArguments>(nullOk: false);
      return CupertinoPageRoute<bool>(
        builder: (context) => EditLocationView(
          key: args.key,
          isHomeTag: args.isHomeTag,
          isWorkTag: args.isWorkTag,
          savedLocation: args.savedLocation,
        ),
        settings: data,
      );
    },
    SearchLocationView: (data) {
      var args = data.getArgs<SearchLocationViewArguments>(nullOk: false);
      return CupertinoPageRoute<bool>(
        builder: (context) => SearchLocationView(
          isEditLocation: args.isEditLocation,
          isHome: args.isHome,
          isWork: args.isWork,
          onDestinationSelected: args.onDestinationSelected,
          key: args.key,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// OTPScreenView arguments holder class
class OTPScreenViewArguments {
  final Key? key;
  final String mobileNumber;
  OTPScreenViewArguments({this.key, required this.mobileNumber});
}

/// BusTripDetailsView arguments holder class
class BusTripDetailsViewArguments {
  final Key? key;
  final BusSchedule? schedule;
  final BusSchedule? busSchedule;
  final List<BusSchedule>? busScheduleList;
  BusTripDetailsViewArguments(
      {this.key, this.schedule, this.busSchedule, this.busScheduleList});
}

/// TicketView arguments holder class
class TicketViewArguments {
  final Key? key;
  final TicketDetails ticketDetails;
  TicketViewArguments({this.key, required this.ticketDetails});
}

/// AllTicketView arguments holder class
class AllTicketViewArguments {
  final Key? key;
  final TicketDetails? ticketDetails;
  AllTicketViewArguments({this.key, this.ticketDetails});
}

/// BookedTicketView arguments holder class
class BookedTicketViewArguments {
  final Key? key;
  final TicketDetails ticketDetails;
  BookedTicketViewArguments({this.key, required this.ticketDetails});
}

/// ShowTicketView arguments holder class
class ShowTicketViewArguments {
  final Key? key;
  final TicketDetails ticketDetails;
  ShowTicketViewArguments({this.key, required this.ticketDetails});
}

/// BusRideView arguments holder class
class BusRideViewArguments {
  final Key? key;
  final TicketDetails? ticketDetails;
  BusRideViewArguments({this.key, this.ticketDetails});
}

/// SearchRideView arguments holder class
class SearchRideViewArguments {
  final Function? onDestinationSelected;
  final Key? key;
  SearchRideViewArguments({this.onDestinationSelected, this.key});
}

/// AvailableBusRoutesView arguments holder class
class AvailableBusRoutesViewArguments {
  final Key? key;
  final TicketDetails? ticketDetails;
  AvailableBusRoutesViewArguments({this.key, this.ticketDetails});
}

/// EditPaymentView arguments holder class
class EditPaymentViewArguments {
  final Key? key;
  final PaymentMethods paymentMethods;
  EditPaymentViewArguments({this.key, required this.paymentMethods});
}

/// AddLocationView arguments holder class
class AddLocationViewArguments {
  final Key? key;
  final bool isHomeTag;
  final bool isWorkTag;
  final AddressDetails savedAddress;
  AddLocationViewArguments(
      {this.key,
      required this.isHomeTag,
      required this.isWorkTag,
      required this.savedAddress});
}

/// EditLocationView arguments holder class
class EditLocationViewArguments {
  final Key? key;
  final bool isHomeTag;
  final bool isWorkTag;
  final SavedLocationModel savedLocation;
  EditLocationViewArguments(
      {this.key,
      required this.isHomeTag,
      required this.isWorkTag,
      required this.savedLocation});
}

/// SearchLocationView arguments holder class
class SearchLocationViewArguments {
  final bool isEditLocation;
  final bool isHome;
  final bool isWork;
  final Function? onDestinationSelected;
  final Key? key;
  SearchLocationViewArguments(
      {required this.isEditLocation,
      required this.isHome,
      required this.isWork,
      this.onDestinationSelected,
      this.key});
}
