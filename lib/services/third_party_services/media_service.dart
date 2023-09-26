

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {

  Future<File?> getImage({bool? fromGallery, BuildContext? context}) async {
    ImagePicker _picker = ImagePicker();

    final _pickedFile = await _picker.getImage(
      source: fromGallery! ? ImageSource.gallery : ImageSource.camera,
      //maxWidth: 1800,
      //maxHeight: 1800,
    );

    if (_pickedFile != null) {
      File? croppedImage = await ImageCropper.cropImage(
          sourcePath: _pickedFile.path,
          compressQuality: 100,
          maxWidth: 512,
          maxHeight: 512,
          aspectRatioPresets: Platform.isAndroid
              ? [
            CropAspectRatioPreset.square,
          ]
              : [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Theme.of(context!).colorScheme.background,
              toolbarWidgetColor: Theme.of(context).colorScheme.onError,
              toolbarTitle: "Crop your image",
              statusBarColor: Theme.of(context).colorScheme.background
          ),
          iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,

          ),
    );
      return croppedImage;
    } else
      return null;
  }

  Future<bool> uploadFile(File fileToUpload, String ref) async {
    try {
      await FirebaseStorage.instance
          .ref(ref)
          .putFile(fileToUpload);

      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Future<String> retrieveProfileImage(String ref) async{
    final reference = FirebaseDatabase.instance.reference();
    reference.child(ref).onValue.listen((event) {
      var snapshot = event.snapshot.value;

      //'user_profiles/$UID'
      print('################### Image upload complete! Value is $snapshot');

      reference.onDisconnect();
      //setBusy(false);
      //return Future.value(snapshot);
    });

    final referenceURL =
    FirebaseStorage.instance.ref().child(ref);
    String url = (await referenceURL.getDownloadURL()).toString();
    print(url);

    return Future.value(url);
  }





//FUNCTION THAT SAVES IMAGE WITH TIME STAMP AND RETRIEVES DOWNLOAD URL
/*
  Future<String>photoOption() async {
    try {
      DateTime now = new DateTime.now();
      var datestamp = new DateFormat("yyyyMMdd'T'HHmmss");
      String currentdate = datestamp.format(now);
      File imageFile = await ImagePicker.pickImage();


      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("images")
          .child("$currentdate.jpg");
      StorageUploadTask uploadTask = ref.putFile(imageFile);

      Uri downloadUrl = (await uploadTask.future).downloadUrl;
      addUser.downloadablelink = downloadUrl.toString();

      downloadableUrl = downloadUrl.toString();

      print(downloadableUrl);

    } catch (error) {
      print(error);
    }

    return downloadableUrl;
  }

   */



}