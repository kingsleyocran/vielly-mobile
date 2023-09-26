import 'package:flutter/material.dart';

import '../../../../data/models/trip.dart';
import '../../view_model.dart';


class AddNoteViewModel extends ViewModel {

  TextEditingController noteController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  bool _isSent = false;
  get isSent => _isSent;

  TripDetails? _tripDetails;
  get tripDetails => _tripDetails;


  initialise() async{

    controllerFocus();
  }

  void controllerFocus() {

    //nameController.text = '';
    noteController.addListener(() {
      notifyListeners();// setState every time text changes
    });

  }



  //CREATE PROFILE
  Future addNote() async{
    print(noteController.text);

    showLoadingDialog('Loading', false);

    bool internet = await internetCheckWithLoading();

    if(!internet){
      return;
    }

    setBusy(true);

    _tripDetails = await getSharedPrefManager.getPrefTrip();
    notifyListeners();

    final Map<String, dynamic> data = Map<String, dynamic>();

    data['msg'] = noteController.text;
    data['ride_id'] = tripDetails.rideID;


    final bool isCreated = await getTripRepositoryImpl.postSendTripMessage(data);

    if(isCreated){
      dismissLoadingDialog();

      initialise();

      _isSent = true;
      notifyListeners();

      navigateBackLogic();

    }else{
      dismissLoadingDialog();

      showDialogFailed(
          title: 'Sending note failed',
          description: 'We could not send your driver a note. Please try again.',
          mainTitle: 'RETRY',
          secondTitle: 'CANCEL'
      ).then((value) {
        if(value){
          this.addNote();
        }else if(!(value)){
          return;
        }
      });
    }


  }

  Future navigateBackLogic() async{

    if(isSent){
      getNavigator.back(result: 'value');
    }else{
      getNavigator.back();
    }

  }










  var tags = [
    "I'm wearing",
    "I'm infront of",
    "I'm at the corner of",
    "You'll be picking up",
  ];

  String _value = '';

  generateTags(context) {
    return tags.map((tag) => getChip(tag, context)).toList();
  }

  getChip(name, context) {
    return ChoiceChip(
      selected: _value == name,
      label: Text(name, style: Theme.of(context).textTheme.headline6),
      elevation: 00,
      pressElevation: 0,
      padding: EdgeInsets.all(15),
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.surface,
      onSelected: (bool selected) {

          if (selected) {
            _value = selected ? name : null;
            noteController.text = name + ' ';
            noteController.selection = TextSelection.fromPosition(TextPosition(offset: noteController.text.length));
            myFocusNode.requestFocus();

            notifyListeners();
          }

      },
    );
  }


}