class SocketOrderStatusData {
  int? orderType;
  int? orderId;
  int? state;
  int? time;

  SocketOrderStatusData({this.orderType, this.orderId, this.state, this.time});

  SocketOrderStatusData.fromJson(Map<String, dynamic> json) {
    orderType = json['orderType'];
    orderId = json['orderId'];
    state = json['state'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderType'] = this.orderType;
    data['orderId'] = this.orderId;
    data['state'] = this.state;
    data['time'] = this.time;
    return data;
  }
}
