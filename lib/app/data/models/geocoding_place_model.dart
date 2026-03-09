class GeocodingPlace {
  double? lat;
  double? lng;
  String? address;
  String? name;
  double? customDistanceM;
  double? customDistanceKm;

  GeocodingPlace({
    this.lat,
    this.lng,
    this.address,
    this.name,
    this.customDistanceM,
    this.customDistanceKm,
  });

  GeocodingPlace.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}
