class RecommendationAccessPoint {
  double? originalLat;
  double? originalLng;
  double? recommendedLat;
  double? recommendedLng;
  bool? corrected;
  double? shiftDistanceMeters;
  String? name;
  String? roadName;
  String? reason;

  RecommendationAccessPoint({
    this.originalLat,
    this.originalLng,
    this.recommendedLat,
    this.recommendedLng,
    this.corrected,
    this.shiftDistanceMeters,
    this.name,
    this.roadName,
    this.reason,
  });

  RecommendationAccessPoint.fromJson(Map<String, dynamic> json) {
    originalLat = json['originalLat'];
    originalLng = json['originalLng'];
    recommendedLat = json['recommendedLat'];
    recommendedLng = json['recommendedLng'];
    corrected = json['corrected'];
    shiftDistanceMeters = json['shiftDistanceMeters'];
    name = json['name'];
    roadName = json['roadName'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['originalLat'] = originalLat;
    data['originalLng'] = originalLng;
    data['recommendedLat'] = recommendedLat;
    data['recommendedLng'] = recommendedLng;
    data['corrected'] = corrected;
    data['shiftDistanceMeters'] = shiftDistanceMeters;
    data['name'] = name;
    data['roadName'] = roadName;
    data['reason'] = reason;
    return data;
  }
}
