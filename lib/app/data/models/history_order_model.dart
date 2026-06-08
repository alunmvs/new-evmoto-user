class HistoryOrder {
  int? orderId;
  String? orderTime;
  String? time;
  String? startAddressName;
  String? startAddress;
  String? endAddressName;
  String? endAddress;
  int? num;
  int? driverId;
  int? state;
  String? cargoName;
  int? carTime;
  String? serverCarModel;
  double? orderMoney;
  double? payMoney;
  double? differenceMoney;
  int? invoice;
  String? orderName;
  int? orderType;
  int? insertTime;
  double? collectionFees;
  String? startLon;
  String? startLat;
  String? endLon;
  String? endLat;
  int? orderScore;
  int? reservation;

  HistoryOrder({
    this.orderId,
    this.orderTime,
    this.time,
    this.startAddressName,
    this.startAddress,
    this.endAddressName,
    this.endAddress,
    this.num,
    this.driverId,
    this.state,
    this.cargoName,
    this.carTime,
    this.serverCarModel,
    this.orderMoney,
    this.payMoney,
    this.differenceMoney,
    this.invoice,
    this.orderName,
    this.orderType,
    this.insertTime,
    this.collectionFees,
    this.startLon,
    this.startLat,
    this.endLon,
    this.endLat,
    this.orderScore,
    this.reservation,
  });

  HistoryOrder.fromJson(Map<String, dynamic> json) {
    reservation = json['reservation'];
    orderId = json['orderId'];
    orderTime = json['orderTime'];
    time = json['time'];
    startAddress = json['startAddress'];
    startAddressName = json['startAddressName'];
    endAddress = json['endAddress'];
    endAddressName = json['endAddressName'];
    num = json['num'];
    driverId = json['driverId'];
    state = json['state'];
    cargoName = json['cargoName'];
    carTime = json['carTime'];
    serverCarModel = json['serverCarModel'];
    orderMoney = json['orderMoney'];
    payMoney = json['payMoney'];
    differenceMoney = json['differenceMoney'];
    invoice = json['invoice'];
    orderName = json['orderName'];
    orderType = json['orderType'];
    insertTime = json['insertTime'];
    collectionFees = json['collectionFees'];
    startLon = json['startLon'];
    startLat = json['startLat'];
    endLon = json['endLon'];
    endLat = json['endLat'];
    orderScore = json['orderScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reservation'] = this.reservation;
    data['orderId'] = this.orderId;
    data['orderTime'] = this.orderTime;
    data['time'] = this.time;
    data['startAddress'] = this.startAddress;
    data['endAddress'] = this.endAddress;
    data['num'] = this.num;
    data['driverId'] = this.driverId;
    data['state'] = this.state;
    data['cargoName'] = this.cargoName;
    data['carTime'] = this.carTime;
    data['serverCarModel'] = this.serverCarModel;
    data['orderMoney'] = this.orderMoney;
    data['payMoney'] = this.payMoney;
    data['differenceMoney'] = this.differenceMoney;
    data['invoice'] = this.invoice;
    data['orderName'] = this.orderName;
    data['orderType'] = this.orderType;
    data['insertTime'] = this.insertTime;
    data['collectionFees'] = this.collectionFees;
    data['startLon'] = this.startLon;
    data['startLat'] = this.startLat;
    data['endLon'] = this.endLon;
    data['endLat'] = this.endLat;
    data['orderScore'] = this.orderScore;
    return data;
  }
}
