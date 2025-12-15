class BalanceHistoryConsumption {
  double? money;
  int? type;
  String? createTime;
  DateTime? createTimeDateTime;

  BalanceHistoryConsumption({this.money, this.type, this.createTime});

  BalanceHistoryConsumption.fromJson(Map<String, dynamic> json) {
    money = json['money'];
    type = json['type'];
    createTime = json['createTime'];
    createTimeDateTime = DateTime.parse(createTime!.replaceFirst(' ', 'T'));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['money'] = this.money;
    data['type'] = this.type;
    data['createTime'] = this.createTime;
    return data;
  }
}
