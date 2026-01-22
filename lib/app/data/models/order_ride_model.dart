class OrderRide {
  int? orderId;
  int? orderType;
  int? type;
  int? state;
  String? insertTime;
  String? travelTime_;
  String? travelTime;
  String? travelTime1;
  String? lineShiftTime;
  String? arriveTime;
  double? startLon;
  double? startLat;
  String? startAddress;
  String? startCity;
  double? endLon;
  double? endLat;
  String? endAddress;
  String? endCity;
  int? driverId;
  String? driverAvatar;
  String? driverName;
  String? licensePlate;
  String? brand;
  String? carColor;
  double? score;
  int? orderNum;
  int? historyNum;
  String? driverPhone;
  double? cancelPayMoney;
  int? cancelId;
  double? orderMoney;
  double? startMileage;
  double? startMoney;
  double? mileage;
  double? mileageMoney;
  double? duration;
  double? durationMoney;
  double? wait;
  double? waitMoney;
  double? longDistance;
  double? longDistanceMoney;
  double? travelMoney;
  double? fastigiumMoney;
  double? nightMoney;
  double? additionalCharge;
  double? collectionFees;
  double? collectionFeesAll;
  double? redPacketMoney;
  double? couponMoney;
  double? discount;
  double? discountMoney;
  int? activityId;
  int? couponId;
  int? payManner;
  double? payMoney;
  double? tipMoney;
  int? orderScore;
  String? evaluate;
  int? device;
  int? peopleNumber;
  String? seatNumber;
  int? cancelUserType;
  String? cancelUser;
  double? cancelMoney;
  String? cancelReason;
  String? cancelRemark;
  String? remark;
  String? cargoNumber;
  String? cargoName;
  String? user;
  String? nickName;
  String? phone;
  String? emergencyCall;
  int? driverConfirm;
  int? userId;
  String? userHeadImg;
  int? weight;
  int? payType;
  String? content;

  OrderRide({
    this.orderId,
    this.orderType,
    this.type,
    this.state,
    this.insertTime,
    this.travelTime_,
    this.travelTime,
    this.travelTime1,
    this.lineShiftTime,
    this.arriveTime,
    this.startLon,
    this.startLat,
    this.startAddress,
    this.startCity,
    this.endLon,
    this.endLat,
    this.endAddress,
    this.endCity,
    this.driverId,
    this.driverAvatar,
    this.driverName,
    this.licensePlate,
    this.brand,
    this.carColor,
    this.score,
    this.orderNum,
    this.historyNum,
    this.driverPhone,
    this.cancelPayMoney,
    this.cancelId,
    this.orderMoney,
    this.startMileage,
    this.startMoney,
    this.mileage,
    this.mileageMoney,
    this.duration,
    this.durationMoney,
    this.wait,
    this.waitMoney,
    this.longDistance,
    this.longDistanceMoney,
    this.travelMoney,
    this.fastigiumMoney,
    this.nightMoney,
    this.additionalCharge,
    this.collectionFees,
    this.collectionFeesAll,
    this.redPacketMoney,
    this.couponMoney,
    this.discount,
    this.discountMoney,
    this.activityId,
    this.couponId,
    this.payManner,
    this.payMoney,
    this.tipMoney,
    this.orderScore,
    this.evaluate,
    this.device,
    this.peopleNumber,
    this.seatNumber,
    this.cancelUserType,
    this.cancelUser,
    this.cancelMoney,
    this.cancelReason,
    this.cancelRemark,
    this.remark,
    this.cargoNumber,
    this.cargoName,
    this.user,
    this.nickName,
    this.phone,
    this.emergencyCall,
    this.driverConfirm,
    this.userId,
    this.userHeadImg,
    this.weight,
    this.payType,
    this.content,
  });

  OrderRide.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderType = json['orderType'];
    type = json['type'];
    state = json['state'];
    insertTime = json['insertTime'];
    travelTime_ = json['travelTime_'];
    travelTime = json['travelTime'];
    travelTime1 = json['travelTime1'];
    lineShiftTime = json['lineShiftTime'];
    arriveTime = json['arriveTime'];
    startLon = json['startLon'];
    startLat = json['startLat'];
    startAddress = json['startAddress'];
    startCity = json['startCity'];
    endLon = json['endLon'];
    endLat = json['endLat'];
    endAddress = json['endAddress'];
    endCity = json['endCity'];
    driverId = json['driverId'];
    driverAvatar = json['driverAvatar'];
    driverName = json['driverName'];
    licensePlate = json['licensePlate'];
    brand = json['brand'];
    carColor = json['carColor'];
    score = json['score'];
    orderNum = json['orderNum'];
    historyNum = json['historyNum'];
    driverPhone = json['driverPhone'];
    cancelPayMoney = json['cancelPayMoney'];
    cancelId = json['cancelId'];
    orderMoney = json['orderMoney'];
    startMileage = json['startMileage'];
    startMoney = json['startMoney'];
    mileage = json['mileage'];
    mileageMoney = json['mileageMoney'];
    duration = json['duration'];
    durationMoney = json['durationMoney'];
    wait = json['wait'];
    waitMoney = json['waitMoney'];
    longDistance = json['longDistance'];
    longDistanceMoney = json['longDistanceMoney'];
    travelMoney = json['travelMoney'];
    fastigiumMoney = json['fastigiumMoney'];
    nightMoney = json['nightMoney'];
    additionalCharge = json['additionalCharge'];
    collectionFees = json['collectionFees'];
    collectionFeesAll = json['collectionFeesAll'];
    redPacketMoney = json['redPacketMoney'];
    couponMoney = json['couponMoney'];
    discount = json['discount'];
    discountMoney = json['discountMoney'];
    activityId = json['activityId'];
    couponId = json['couponId'];
    payManner = json['payManner'];
    payMoney = json['payMoney'];
    tipMoney = json['tipMoney'];
    orderScore = json['orderScore'];
    evaluate = json['evaluate'];
    device = json['device'];
    peopleNumber = json['peopleNumber'];
    seatNumber = json['seatNumber'];
    cancelUserType = json['cancelUserType'];
    cancelUser = json['cancelUser'];
    cancelMoney = json['cancelMoney'];
    cancelReason = json['cancelReason'];
    cancelRemark = json['cancelRemark'];
    remark = json['remark'];
    cargoNumber = json['cargoNumber'];
    cargoName = json['cargoName'];
    user = json['user'];
    nickName = json['nickName'];
    phone = json['phone'];
    emergencyCall = json['emergencyCall'];
    driverConfirm = json['driverConfirm'];
    userId = json['userId'];
    userHeadImg = json['userHeadImg'];
    weight = json['weight'];
    payType = json['payType'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderType'] = this.orderType;
    data['type'] = this.type;
    data['state'] = this.state;
    data['insertTime'] = this.insertTime;
    data['travelTime_'] = this.travelTime_;
    data['travelTime'] = this.travelTime;
    data['travelTime1'] = this.travelTime1;
    data['lineShiftTime'] = this.lineShiftTime;
    data['arriveTime'] = this.arriveTime;
    data['startLon'] = this.startLon;
    data['startLat'] = this.startLat;
    data['startAddress'] = this.startAddress;
    data['startCity'] = this.startCity;
    data['endLon'] = this.endLon;
    data['endLat'] = this.endLat;
    data['endAddress'] = this.endAddress;
    data['endCity'] = this.endCity;
    data['driverId'] = this.driverId;
    data['driverAvatar'] = this.driverAvatar;
    data['driverName'] = this.driverName;
    data['licensePlate'] = this.licensePlate;
    data['brand'] = this.brand;
    data['carColor'] = this.carColor;
    data['score'] = this.score;
    data['orderNum'] = this.orderNum;
    data['historyNum'] = this.historyNum;
    data['driverPhone'] = this.driverPhone;
    data['cancelPayMoney'] = this.cancelPayMoney;
    data['cancelId'] = this.cancelId;
    data['orderMoney'] = this.orderMoney;
    data['startMileage'] = this.startMileage;
    data['startMoney'] = this.startMoney;
    data['mileage'] = this.mileage;
    data['mileageMoney'] = this.mileageMoney;
    data['duration'] = this.duration;
    data['durationMoney'] = this.durationMoney;
    data['wait'] = this.wait;
    data['waitMoney'] = this.waitMoney;
    data['longDistance'] = this.longDistance;
    data['longDistanceMoney'] = this.longDistanceMoney;
    data['travelMoney'] = this.travelMoney;
    data['fastigiumMoney'] = this.fastigiumMoney;
    data['nightMoney'] = this.nightMoney;
    data['additionalCharge'] = this.additionalCharge;
    data['collectionFees'] = this.collectionFees;
    data['collectionFeesAll'] = this.collectionFeesAll;
    data['redPacketMoney'] = this.redPacketMoney;
    data['couponMoney'] = this.couponMoney;
    data['discount'] = this.discount;
    data['discountMoney'] = this.discountMoney;
    data['activityId'] = this.activityId;
    data['couponId'] = this.couponId;
    data['payManner'] = this.payManner;
    data['payMoney'] = this.payMoney;
    data['tipMoney'] = this.tipMoney;
    data['orderScore'] = this.orderScore;
    data['evaluate'] = this.evaluate;
    data['device'] = this.device;
    data['peopleNumber'] = this.peopleNumber;
    data['seatNumber'] = this.seatNumber;
    data['cancelUserType'] = this.cancelUserType;
    data['cancelUser'] = this.cancelUser;
    data['cancelMoney'] = this.cancelMoney;
    data['cancelReason'] = this.cancelReason;
    data['cancelRemark'] = this.cancelRemark;
    data['remark'] = this.remark;
    data['cargoNumber'] = this.cargoNumber;
    data['cargoName'] = this.cargoName;
    data['user'] = this.user;
    data['nickName'] = this.nickName;
    data['phone'] = this.phone;
    data['emergencyCall'] = this.emergencyCall;
    data['driverConfirm'] = this.driverConfirm;
    data['userId'] = this.userId;
    data['userHeadImg'] = this.userHeadImg;
    data['weight'] = this.weight;
    data['payType'] = this.payType;
    data['content'] = this.content;
    return data;
  }
}
