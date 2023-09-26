class DirectionDetails {
  String? distanceText;
  String? durationText;
  int? distanceValue;
  int? durationValue;
  String? encodedPoints;

  DirectionDetails({
    this.distanceText,
    this.durationText,
    this.distanceValue,
    this.durationValue,
    this.encodedPoints
  });

  DirectionDetails.fromJson(Map<String, dynamic> json){
    distanceText = json['distanceText'];
    durationText = json['durationText'];
    distanceValue = json['distanceValue'];
    durationValue = json['durationValue'];
    encodedPoints = json['encodedPoints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['distanceText'] = this.distanceText;
    data['durationText'] = this.durationText;
    data['distanceValue'] = this.distanceValue;
    data['durationValue'] = this.durationValue;
    data['encodedPoints'] = this.encodedPoints;
    return data;
  }

}