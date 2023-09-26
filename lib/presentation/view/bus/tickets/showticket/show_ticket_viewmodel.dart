

import 'dart:typed_data';
import 'package:flutter/services.dart';


import '../../../../../data/models/ticket.dart';
import '../../../../../data/models/user.dart';
import '../../../../../presentation/view/view_model.dart';

class ShowTicketViewModel extends ViewModel {

  TicketDetails? _ticketDetails;
  get ticketDetails => _ticketDetails;

  UserDetails? _userProfile;
  get userProfile => _userProfile;

  ByteData? _byteData;
  get byteData => _byteData;


  Future initialized(value) async{

    _ticketDetails = value;
    notifyListeners();

    //USER PROFILES FETCHING
    var userPref = await getSharedPrefManager.getPrefUserProfile();
    _userProfile = userPref;
    notifyListeners();

  }


}