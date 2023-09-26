
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideHistory {
  LocationDetails? pickup;
  LocationDetails? dropOff;
  bool? isConfirmed;
  String? passengerCount;
  String? tripDistance;
  num? createdAt;
  num? createdAtNano;
  dynamic charge;

  String? pickupLocation;
  LatLng? pickupLatLng;

  String? dropoffLocation;
  LatLng? dropoffLatLng;


  RideHistory({
    this.pickup,
    this.dropOff,
    this.isConfirmed,
    this.passengerCount ,
    this.tripDistance,
    this.createdAt,
    this.createdAtNano,
    this.charge,

  });

  RideHistory.fromJson(Map<String, dynamic> json){
    //pickup = LocationDetails.fromJson(json['pickupTerminal']);
    //dropOff = LocationDetails.fromJson(json['dropoffTerminal']);

    isConfirmed = json['confirmed'];
    charge = json['charge'];
    tripDistance = (json['tripDistance']).toString();
    passengerCount = (json['passengerCount']).toString();
    createdAt = ((json['created_at']['_seconds']));
    createdAtNano = ((json['created_at']['_nanoseconds']));

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();

    data['pickupTerminal'] = this.pickup!.toJson();
    data['dropoffTerminal'] = this.dropOff!.toJson();
    data['confirmed'] = this.isConfirmed;
    data['charge'] = this.charge;
    data['tripDistance'] = this.tripDistance;
    data['passengerCount'] = this.passengerCount;
    data['createdAt']  = {
      "_seconds": this.createdAt,
      "_nanoseconds": this.createdAtNano,
    };

    return data;
  }

}





class LocationDetails {
  String? location;
  String? name;
  double? latitude;
  double? longitude;

  LocationDetails({
    this.location,
    this.name,
    this.latitude,
    this.longitude,
  });

  LocationDetails.fromJson(Map<String, dynamic> json){
    location = json['location'] == null ? 'null' : json['location'];
    name = json['name'] == null ? 'null' : json['name'];
    latitude = json['coords']['latitude'] == null ? 2.3444 : json['coords']['latitude'];
    longitude = json['coords']['longitude'] == null ? 5.2334 : json['coords']['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['location'] = this.location;
    data['name'] = this.name;
    data['coords'] = {
      "longitude": this.longitude,
      "latitude": this.latitude
    };

    return data;
  }

}

