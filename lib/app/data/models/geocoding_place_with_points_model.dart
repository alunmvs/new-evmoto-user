import 'package:new_evmoto_user/app/data/models/geocoding_point_recommendation_model.dart';

class GeocodingPlaceWithPoints {
  double? lat;
  double? lng;
  String? address;
  String? name;
  String? placeId;
  double? distanceMeters;
  String? type;
  String? structureType;
  GeocodingPointRecommendation? pointRecommendation;

  GeocodingPlaceWithPoints({
    this.lat,
    this.lng,
    this.address,
    this.name,
    this.placeId,
    this.distanceMeters,
    this.type,
    this.structureType,
    this.pointRecommendation,
  });

  GeocodingPlaceWithPoints.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    name = json['name'];
    placeId = json['placeId'];
    distanceMeters = json['distanceMeters'];
    type = json['type'];
    structureType = json['structureType'];
    pointRecommendation = json['pointRecommendation'] != null
        ? GeocodingPointRecommendation.fromJson(
            Map<String, dynamic>.from(json['pointRecommendation']),
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    data['address'] = address;
    data['name'] = name;
    data['placeId'] = placeId;
    data['distanceMeters'] = distanceMeters;
    data['type'] = type;
    data['structureType'] = structureType;
    data['pointRecommendation'] = pointRecommendation?.toJson();
    return data;
  }
}
