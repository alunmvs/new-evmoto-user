class OrderRideServer {
  int? orderId;
  int? orderType;
  String? lon;
  String? lat;
  String? reservationMileage;
  String? reservationTime;
  String? servedMileage;
  String? servedTime;
  String? laveMileage;
  String? laveTime;
  int? state;

  OrderRideServer({
    this.orderId,
    this.orderType,
    this.lon,
    this.lat,
    this.reservationMileage,
    this.reservationTime,
    this.servedMileage,
    this.servedTime,
    this.laveMileage,
    this.laveTime,
    this.state,
  });

  OrderRideServer.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderType = json['orderType'];
    lon = json['lon'];
    lat = json['lat'];
    reservationMileage = json['reservationMileage'];
    reservationTime = json['reservationTime'];
    servedMileage = json['servedMileage'];
    servedTime = json['servedTime'];
    laveMileage = json['laveMileage'];
    laveTime = json['laveTime'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderType'] = this.orderType;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['reservationMileage'] = this.reservationMileage;
    data['reservationTime'] = this.reservationTime;
    data['servedMileage'] = this.servedMileage;
    data['servedTime'] = this.servedTime;
    data['laveMileage'] = this.laveMileage;
    data['laveTime'] = this.laveTime;
    data['state'] = this.state;
    return data;
  }
}
