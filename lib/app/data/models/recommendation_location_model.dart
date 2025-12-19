class RecommendationLocation {
  String? id;
  String? name;
  String? addressDetail;
  String? latitude;
  String? longitude;

  RecommendationLocation({
    this.name,
    this.addressDetail,
    this.latitude,
    this.longitude,
    this.id,
  });

  RecommendationLocation.fromJson(Map<String, dynamic> json) {
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
