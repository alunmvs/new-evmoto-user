class RecommendationLocation {
  String? id;
  String? name;
  String? addressDetail;
  String? latitude;
  String? longitude;
  double? customDistanceM;
  double? customDistanceKm;

  RecommendationLocation({
    this.name,
    this.addressDetail,
    this.latitude,
    this.longitude,
    this.id,
    this.customDistanceM,
    this.customDistanceKm,
  });

  RecommendationLocation.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    name = json['name'];
    addressDetail = json['address_detail'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address_detail'] = this.addressDetail;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
