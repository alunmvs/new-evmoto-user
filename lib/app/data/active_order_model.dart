class ActiveOrder {
  int? orderId;
  int? orderType;
  int? state;

  ActiveOrder({this.orderId, this.orderType, this.state});

  ActiveOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderType = json['orderType'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderType'] = this.orderType;
    data['state'] = this.state;
    return data;
  }
}
