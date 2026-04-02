class ActiveOrder {
  int? orderId;
  int? orderType;
  int? state;
  String? startAddress;
  String? endAddress;
  String? travelTime;
  double? collectionFees;
  double? orderMoney;
  double? startLat;
  double? startLon;
  double? endLat;
  double? endLon;
  int? driverId;

  ActiveOrder({
    this.orderId,
    this.orderType,
    this.state,
    this.startAddress,
    this.endAddress,
    this.travelTime,
    this.collectionFees,
    this.orderMoney,
    this.startLat,
    this.startLon,
    this.endLat,
    this.endLon,
    this.driverId,
  });

  ActiveOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderType = json['orderType'];
    state = json['state'];
    startAddress = json['startAddress'];
    endAddress = json['endAddress'];
    travelTime = json['travelTime'];
    collectionFees = json['collectionFees'];
    orderMoney = json['orderMoney'];
    startLat = json['startLat'];
    startLon = json['startLon'];
    endLat = json['endLat'];
    endLon = json['endLon'];
    driverId = json['driverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderType'] = this.orderType;
    data['state'] = this.state;
    data['driverId'] = this.driverId;
    return data;
  }
}
