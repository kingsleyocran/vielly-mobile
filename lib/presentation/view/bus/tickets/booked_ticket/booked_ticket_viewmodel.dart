import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked_services/stacked_services.dart';


import '../../../../../app/app.router.dart';
import '../../../../../data/models/ticket.dart';
import '../../../../../data/models/user.dart';
import '../../../../../presentation/view/view_model.dart';

class BookedTicketViewModel extends ViewModel {

  TicketDetails? _ticketDetails;
  get ticketDetails => _ticketDetails;

  UserDetails? _userProfile;
  get userProfile => _userProfile;

  ByteData? _byteData;
  get byteData => _byteData;

  BuildContext appContext = Get.context!;




  Future navigatePOP() async{
    getNavigator.popRepeated(3);
  }

  Future initialized(value) async{

    _ticketDetails = value;
    notifyListeners();

    //USER PROFILES FETCHING
    var userPref = await getSharedPrefManager.getPrefUserProfile();
    _userProfile = userPref;
    notifyListeners();

  }

  Future startBusTrip() async{

    //showBusNotStarted();

    getNavigator.navigateTo(Routes.busRideView,
    arguments: BusRideViewArguments(
      ticketDetails: ticketDetails,
    ));
  }



  //DOWNLOAD AND SHARE//////////////////////
  Future downloadTicket({globalKey})async{

    var result = await capturePng(globalKey);
    if (result != null){
      await downloadImage();
    }else{print('FAILED');}

  }

  Future shareTicket({globalKey})async{

    var result = await capturePng(globalKey);
    if (result != null){
      await shareTicketFile();
    }



    /*
    Share.share(
        'Hi ${userProfile.name} here, \n\n'
            'TICKET DETAILS. \n'
            'Driver name: ${ticketDetails.ticketNumber}. \n'
            'Bus Lane: ${ticketDetails.laneName}. \n'
            'Date of order: ${ticketDetails.dateOfOrder}. \n'

            ,
        subject: '');

     */


  }

  Future<Uint8List> capturePng (globalKey) async {

      print('CONVERTING TICKET TO BYTEDATA');
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteDataVar = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteDataVar!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print("PNG BYTES - $pngBytes");
      print("BS64 - $bs64");

      _byteData = byteDataVar;
      notifyListeners();

      print('CONVERTING TICKET TO BYTEDATA DONE');
      return (pngBytes);
  }
  //Preview the ticket
  //Image.memory(base64Decode(base64String));

  Future downloadImage() async{

    /*
    final isPermissionStatusGranted = await requestPermissions();

    if(!isPermissionStatusGranted) {
      showSnackBarRedAlert('Make sure the app has write permission');
      return;
    }

     */

    showLoadingDialog('${AppLocalizations.of(appContext)!.downloading}', false);

    try{

      Directory? downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      final downloadPath = downloadsDirectory!.path;
      //final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = byteData.buffer.asUint8List();
      File imgFile = new File('$downloadPath/TICKET-${ticketDetails.ticketNumber}.png');
      imgFile.writeAsBytes(pngBytes);

    }catch (e){
      print(e);
      showSnackBarRedAlert('${AppLocalizations.of(appContext)!.downloadTicketFailed}');
    }
    dismissLoadingDialog();

    showSnackBarGreenAlert('${AppLocalizations.of(appContext)!.downloadTicketSuccess}');


    /*
    final result = await MediaStore.saveImage(byteData.buffer.asUint8List());


    final result = await MediaStore.saveFile('$directory/TICKET-${ticketDetails.ticketNumber}.png');

    if(result == null){
      showSnackBarRedAlert('Failed to download ticket');
    }
    else if(result != null){
      showSnackBarGreenAlert('Ticket downloaded successfully');
      print(result);
    }

     */



  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future shareTicketFile() async {
    /*
    final isPermissionStatusGranted = await requestPermissions();

    if(!isPermissionStatusGranted) {
      showSnackBarRedAlert('Make sure the app has write permission');
      return;
    }

     */

    try {

      final directory = (await getExternalStorageDirectory())!.path;
      Uint8List pngBytes = byteData.buffer.asUint8List();
      File imgFile = new File('$directory/ticket.png');
      imgFile.writeAsBytes(pngBytes);
      //final RenderBox box = context.findRenderObject();
      Share.shareFiles(['$directory/ticket.png'],
          text: 'BUS TICKET NUMBER ${ticketDetails.ticketNumber}',
          //sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
      );
    } catch (e) {
      print("Exception while taking screenshot:" + e.toString());
      showSnackBarRedAlert('Failed to share image');
    }

  }

  /*
  Future<bool> requestPermissions() async {
    var permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

   */


  /*
  _save() async {
    var response = await Dio().get("https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg", options: Options(responseType: ResponseType.bytes));
    final result = await MediaStore.saveImage(Uint8List.fromList(response.data));
    print(result);
  }
  _saveVideo() async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/temp.mp4";
    await Dio().download("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", savePath);
    final result = await MediaStore.saveFile(savePath);
    print(result);
  }

   */
}