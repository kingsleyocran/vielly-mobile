class BusTerminal {
  String? busTerminalID;
  String? busTerminalName;
  double? busTerminalLatitude;
  double? busTerminalLongitude;



  BusTerminal({
    this.busTerminalID,
    this.busTerminalName,
    this.busTerminalLatitude,
    this.busTerminalLongitude,
  });

  BusTerminal.fromJson(Map<String, dynamic> json){
    busTerminalID = (json['id']).toString();
    busTerminalName = json['name'];
    busTerminalLongitude = json['longitude'];
    busTerminalLatitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['id'] = (this.busTerminalID).toString();
    data['name'] = this.busTerminalName;
    data['latitude'] = this.busTerminalLatitude;
    data['longitude'] = this.busTerminalLongitude;

    return data;
  }

}

