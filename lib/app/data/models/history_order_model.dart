import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';

class HistoryOrder {
  int? orderId;
  String? orderTime;
  String? time;
  String? startAddress;
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

  HistoryOrder({
    this.orderId,
    this.orderTime,
    this.time,
    this.startAddress,
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
  });

  HistoryOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderTime = json['orderTime'];
    time = json['time'];
    startAddress = json['startAddress'];
    endAddress = json['endAddress'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }
}
