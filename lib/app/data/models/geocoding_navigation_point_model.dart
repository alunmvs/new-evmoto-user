class GeocodingNavigationPoint {
  double? rawLat;
  double? rawLng;
  double? osrmLat;
  double? osrmLng;
  double? shiftMeters;
  String? name;
  List<String>? usages;
  double? customDistanceM;
  double? customDistanceKm;

  GeocodingNavigationPoint({
    this.rawLat,
    this.rawLng,
    this.osrmLat,
    this.osrmLng,
    this.shiftMeters,
    this.name,
    this.usages,
    this.customDistanceM,
    this.customDistanceKm,
  });

  GeocodingNavigationPoint.fromJson(Map<String, dynamic> json) {
    rawLat = json['rawLat'];
    rawLng = json['rawLng'];
    osrmLat = json['osrmLat'];
    osrmLng = json['osrmLng'];
    shiftMeters = json['shiftMeters'];
    name = json['name'];
    usages = json['usages'] != null
        ? List<String>.from(json['usages'].map((usage) => usage.toString()))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rawLat'] = rawLat;
    data['rawLng'] = rawLng;
    data['osrmLat'] = osrmLat;
    data['osrmLng'] = osrmLng;
    data['shiftMeters'] = shiftMeters;
    data['name'] = name;
    data['usages'] = usages;
    return data;
  }
}
