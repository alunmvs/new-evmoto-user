class DriverNearby {
  int? driverId;
  double? lat;
  double? lon;
  double? heading;
  double? speed;
  double? distance;

  DriverNearby({
    this.driverId,
    this.lat,
    this.lon,
    this.heading,
    this.speed,
    this.distance,
  });

  DriverNearby.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    lat = json['lat'];
    lon = json['lon'];
    heading = json['heading'];
    speed = json['speed'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driverId'] = this.driverId;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['heading'] = this.heading;
    data['speed'] = this.speed;
    data['distance'] = this.distance;
    return data;
  }
}
