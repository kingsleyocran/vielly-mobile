class AddressDetails{
  String? placeName;
  String? placeID;
  double? longitude;
  double? latitude;
  String? placeFormattedAddress;

  AddressDetails({
    this.placeName,
    this.placeID,
    this.longitude,
    this.latitude,
    this.placeFormattedAddress,
  });


  AddressDetails.fromJson(Map<String, dynamic> json){
    placeName = json['placeName'];
    placeID = json['placeID'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    placeFormattedAddress = json['placeFormattedAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['placeName'] = this.placeName;
    data['placeID'] = this.placeID;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['placeFormattedAddress'] = this.placeFormattedAddress;

    return data;
  }
}


