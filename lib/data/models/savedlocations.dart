import 'package:google_maps_flutter/google_maps_flutter.dart';

class SavedLocationModel{
  String? savedLocationID;
  String? name;
  String? tag;
  LatLng? location;

  SavedLocationModel({
    this.savedLocationID,
    this.name,
    this.tag,
    this.location
  });

  SavedLocationModel.fromJson(Map<String, dynamic> json){
    savedLocationID = json['id'];
    name = json['name'];
    tag = json['tag'];
    location = LatLng(json['location']['latitude'], json['location']['longitude']);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['id'] = this.savedLocationID;
    data['name'] = this.name;
    data['tag'] = this.tag;
    data['location']  = {
      "latitude": this.location!.latitude,
      "longitude": this.location!.longitude,
    };

    return data;
  }
}