class BalanceHistoryConsumption {
  int? money;
  int? type;
  String? createTime;

  BalanceHistoryConsumption({this.money, this.type, this.createTime});

  BalanceHistoryConsumption.fromJson(Map<String, dynamic> json) {
    money = json['money'];
    type = json['type'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['money'] = this.money;
    data['type'] = this.type;
    data['createTime'] = this.createTime;
    return data;
  }
}
