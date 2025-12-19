abstract class HasCreatedAtDateTime {
  DateTime? get createTimeDateTime;
}

class BalanceHistoryDeposit implements HasCreatedAtDateTime {
  @override
  DateTime? createTimeDateTime;

  double? lastBalance;
  double? amount;
  String? createTime;
  int? id;
  int? userId;

  BalanceHistoryDeposit({
    this.lastBalance,
    this.amount,
    this.createTime,
    this.id,
    this.userId,
    this.createTimeDateTime,
  });

  BalanceHistoryDeposit.fromJson(Map<String, dynamic> json) {
    lastBalance = json['lastBalance'];
    amount = json['amount'];
    createTime = json['createTime'];
    id = json['id'];
    userId = json['userId'];
    createTimeDateTime = DateTime.parse(createTime!.replaceFirst(' ', 'T'));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastBalance'] = this.lastBalance;
    data['amount'] = this.amount;
    data['createTime'] = this.createTime;
    data['id'] = this.id;
    data['userId'] = this.userId;
    return data;
  }
}
