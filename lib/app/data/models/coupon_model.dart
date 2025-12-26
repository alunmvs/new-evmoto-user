class Coupon {
  int? id;
  int? couponType;
  double? money;
  double? residualAmount;
  int? userType;
  String? time;
  int? type;
  double? fullMoney;
  double? discount;
  String? name;
  int? state;

  Coupon({
    this.id,
    this.couponType,
    this.money,
    this.residualAmount,
    this.userType,
    this.time,
    this.type,
    this.fullMoney,
    this.discount,
    this.name,
    this.state,
  });

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponType = json['couponType'];
    money = json['money'];
    residualAmount = json['residualAmount'];
    userType = json['userType'];
    time = json['time'];
    type = json['type'];
    fullMoney = json['fullMoney'];
    discount = json['discount'];
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['couponType'] = this.couponType;
    data['money'] = this.money;
    data['residualAmount'] = this.residualAmount;
    data['userType'] = this.userType;
    data['time'] = this.time;
    data['type'] = this.type;
    data['fullMoney'] = this.fullMoney;
    data['discount'] = this.discount;
    data['name'] = this.name;
    data['state'] = this.state;
    return data;
  }
}
