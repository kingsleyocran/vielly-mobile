

class UserDetails {

  String? name;
  String? email;
  String? phone;
  bool? isDriver = false;
  String? originalImage;
  String? thumbnailImage;
  String? referralCode;
  num? wallet;
  int? rating;
  int? ratingCount;
  int? ratingTotal;

  UserDetails({

    this.name,
    this.email,
    this.phone,
    this.originalImage,
    this.thumbnailImage,
    this.referralCode,
    this.wallet,
    this.rating,
    this.ratingCount,
    this.ratingTotal,
  });

  UserDetails.fromJson(Map<String, dynamic> json){

    name = json['name'];
    email = json['email'];
    phone = json['phone_number'];
    originalImage = json['profile_image_original'];
    thumbnailImage = json['profie_image_thumbnail'];
    referralCode = json['referral_code'];
    wallet = json['wallet'];
    //rating = json['rating']['rating'] ?? 0;
    //ratingCount = json['rating']['number_of_ratings'] ?? 0;
    //ratingTotal = json['rating']['total_ratings'] ?? 0;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =new Map<String, dynamic>();

    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phone;
    data['referral_code'] = this.referralCode;
    data['profile_image_original'] = this.originalImage;
    data['profie_image_thumbnail'] = this.thumbnailImage;
    data['wallet'] = this.wallet;
   // data['rating'] = {
    //  "rating": this.rating,
    //  "number_of_ratings": this.ratingCount,
    //  "total_ratings": this.ratingTotal
   // };
    return data;
  }
}