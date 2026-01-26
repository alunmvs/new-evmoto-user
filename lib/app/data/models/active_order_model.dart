import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';

class ActiveOrder {
  int? orderId;
  int? orderType;
  int? state;
  String? endAddress;
  String? travelTime;
  double? collectionFees;
  double? orderMoney;

  ActiveOrder({
    this.orderId,
    this.orderType,
    this.state,
    this.endAddress,
    this.travelTime,
    this.collectionFees,
    this.orderMoney,
  });

  ActiveOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderType = json['orderType'];
    state = json['state'];

    endAddress = json['endAddress'];
    travelTime = json['travelTime'];
    collectionFees = json['collectionFees'];
    orderMoney = json['orderMoney'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderType'] = this.orderType;
    data['state'] = this.state;
    return data;
  }
}
