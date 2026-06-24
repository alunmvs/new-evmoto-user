class GeocodingNavigationPoint {
  double? rawLat;
  double? rawLng;
  double? osrmLat;
  double? osrmLng;
  double? shiftMeters;
  String? name;
  List<String>? usages;
  double? distanceUserToOsrmMeters;
  double? distanceUserToRawMeters;

  GeocodingNavigationPoint({
    this.rawLat,
    this.rawLng,
    this.osrmLat,
    this.osrmLng,
    this.shiftMeters,
    this.name,
    this.usages,
    this.distanceUserToOsrmMeters,
    this.distanceUserToRawMeters,
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
    distanceUserToOsrmMeters = json['distanceUserToOsrmMeters'];
    distanceUserToRawMeters = json['distanceUserToRawMeters'];
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
    data['distanceUserToOsrmMeters'] = distanceUserToOsrmMeters;
    data['distanceUserToRawMeters'] = distanceUserToRawMeters;
    return data;
  }
}
