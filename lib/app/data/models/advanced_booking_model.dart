class AdvancedBooking {
  int? id;
  int? userId;
  String? startAddress;
  String? startAddressName;
  double? startLon;
  double? startLat;
  String? endAddress;
  String? endAddressName;
  double? endLon;
  double? endLat;
  String? travelTime;
  double? orderMoney;
  int? payMoney;
  int? payType;
  int? payManner;
  int? substitute;
  String? passengers;
  String? passengersPhone;
  String? remark;
  int? state;
  int? orderId;
  int? spawnedOrderState;
  int? driverId;
  String? insertTime;
  int? orderType;

  double? additionalCharge;
  double? startMoney;
  double? waitMoney;
  double? mileageMoney;
  double? durationMoney;
  double? longDistanceMoney;
  double? nightMoney;
  double? fastigiumMoney;
  double? couponMoney;
  double? discountMoney;

  AdvancedBooking({
    this.additionalCharge,
    this.startMoney,
    this.waitMoney,
    this.mileageMoney,
    this.durationMoney,
    this.longDistanceMoney,
    this.nightMoney,
    this.orderType,
    this.fastigiumMoney,
    this.couponMoney,
    this.discountMoney,
    this.payMoney,
    this.id,
    this.userId,
    this.startAddress,
    this.startAddressName,
    this.startLon,
    this.startLat,
    this.endAddress,
    this.endAddressName,
    this.endLon,
    this.endLat,
    this.travelTime,
    this.orderMoney,
    this.payType,
    this.payManner,
    this.substitute,
    this.passengers,
    this.passengersPhone,
    this.remark,
    this.state,
    this.orderId,
    this.spawnedOrderState,
    this.driverId,
    this.insertTime,
  });

  AdvancedBooking.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    spawnedOrderState = json['spawnedOrderState'];

    // state = 2;
    // spawnedOrderState = 9;

    orderType = json['orderType'];
    payMoney = json['payMoney'];
    id = json['id'];
    userId = json['userId'];
    startAddress = json['startAddress'];
    startAddressName = json['startAddressName'];
    startLon = json['startLon'];
    startLat = json['startLat'];
    endAddress = json['endAddress'];
    endAddressName = json['endAddressName'];
    endLon = json['endLon'];
    endLat = json['endLat'];
    travelTime = json['travelTime'];
    orderMoney = json['orderMoney'];
    payType = json['payType'];
    payManner = json['payManner'];
    substitute = json['substitute'];
    passengers = json['passengers'];
    passengersPhone = json['passengersPhone'];
    remark = json['remark'];
    orderId = json['orderId'];
    driverId = json['driverId'];
    insertTime = json['insertTime'];

    additionalCharge = json['additionalCharge'];
    startMoney = json['startMoney'];
    waitMoney = json['waitMoney'];
    mileageMoney = json['mileageMoney'];
    durationMoney = json['durationMoney'];
    longDistanceMoney = json['longDistanceMoney'];
    nightMoney = json['nightMoney'];
    fastigiumMoney = json['fastigiumMoney'];
    couponMoney = json['couponMoney'];
    discountMoney = json['discountMoney'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderType'] = this.orderType;
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['startAddress'] = this.startAddress;
    data['startAddressName'] = this.startAddressName;
    data['startLon'] = this.startLon;
    data['startLat'] = this.startLat;
    data['endAddress'] = this.endAddress;
    data['endAddressName'] = this.endAddressName;
    data['endLon'] = this.endLon;
    data['endLat'] = this.endLat;
    data['travelTime'] = this.travelTime;
    data['orderMoney'] = this.orderMoney;
    data['payType'] = this.payType;
    data['payManner'] = this.payManner;
    data['substitute'] = this.substitute;
    data['passengers'] = this.passengers;
    data['passengersPhone'] = this.passengersPhone;
    data['remark'] = this.remark;
    data['state'] = this.state;
    data['orderId'] = this.orderId;
    data['spawnedOrderState'] = this.spawnedOrderState;
    data['driverId'] = this.driverId;
    data['insertTime'] = this.insertTime;
    data['payMoney'] = this.payMoney;
    return data;
  }
}
