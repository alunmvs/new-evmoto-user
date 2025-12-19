class DepositBalance {
  String? token;
  String? redirectUrl;
  String? orderId;

  DepositBalance({this.token, this.redirectUrl, this.orderId});

  DepositBalance.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    redirectUrl = json['redirect_url'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['redirect_url'] = this.redirectUrl;
    data['order_id'] = this.orderId;
    return data;
  }
}
