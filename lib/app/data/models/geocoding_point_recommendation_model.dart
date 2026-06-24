import 'package:new_evmoto_user/app/data/models/geocoding_navigation_point_model.dart';

class GeocodingPointRecommendation {
  String? address;
  String? name;
  String? source;
  List<GeocodingNavigationPoint>? navigationPoints;
  GeocodingNavigationPoint? fallbackPoint;

  GeocodingPointRecommendation({
    this.address,
    this.name,
    this.source,
    this.navigationPoints,
    this.fallbackPoint,
  });

  GeocodingPointRecommendation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    name = json['name'];
    source = json['source'];
    navigationPoints = json['navigationPoints'] != null
        ? (json['navigationPoints'] as List)
            .map(
              (point) => GeocodingNavigationPoint.fromJson(
                Map<String, dynamic>.from(point),
              ),
            )
            .toList()
        : null;
    fallbackPoint = json['fallbackPoint'] != null
        ? GeocodingNavigationPoint.fromJson(
            Map<String, dynamic>.from(json['fallbackPoint']),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['name'] = name;
    data['source'] = source;
    data['navigationPoints'] =
        navigationPoints?.map((point) => point.toJson()).toList();
    data['fallbackPoint'] = fallbackPoint?.toJson();
    return data;
  }
}
