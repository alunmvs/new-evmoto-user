class SocketDriverPositionData {
  String? orderType;
  String? servedMileage;
  String? orderId;
  String? reservationTime;
  String? servedTime;
  String? reservationMileage;
  String? laveMileage;
  String? lon;
  String? lat;
  String? laveTime;

  SocketDriverPositionData({
    this.orderType,
    this.servedMileage,
    this.orderId,
    this.reservationTime,
    this.servedTime,
    this.reservationMileage,
    this.laveMileage,
    this.lon,
    this.lat,
    this.laveTime,
  });

  SocketDriverPositionData.fromJson(Map<String, dynamic> json) {
    orderType = json['orderType'];
    servedMileage = json['servedMileage'];
    orderId = json['orderId'];
    reservationTime = json['reservationTime'];
    servedTime = json['servedTime'];
    reservationMileage = json['reservationMileage'];
    laveMileage = json['laveMileage'];
    lon = json['lon'];
    lat = json['lat'];
    laveTime = json['laveTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderType'] = this.orderType;
    data['servedMileage'] = this.servedMileage;
    data['orderId'] = this.orderId;
    data['reservationTime'] = this.reservationTime;
    data['servedTime'] = this.servedTime;
    data['reservationMileage'] = this.reservationMileage;
    data['laveMileage'] = this.laveMileage;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['laveTime'] = this.laveTime;
    return data;
  }
}
