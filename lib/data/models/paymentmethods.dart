class PaymentMethods{
  String ?paymentID;
  bool? isPrimary;
  String? provider;
  String? phone;
  String? type;

  PaymentMethods({
    this.paymentID,
    this.isPrimary,
    this.provider,
    this.phone,
    this.type,
  });

  PaymentMethods.fromJson(Map<String, dynamic> json){
    paymentID = json['id'];
    type = json['type'];
    isPrimary = json['is_primary'];
    provider = json['provider'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['id'] = this.paymentID;
    data['type'] = this.type;
    data['is_primary'] = this.isPrimary;
    data['provider'] = this.provider;
    data['phone'] = this.phone;
    return data;
  }
}