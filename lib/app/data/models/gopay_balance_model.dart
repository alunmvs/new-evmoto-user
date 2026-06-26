class GopayBalance {
  bool? linked;
  String? accountStatus;
  double? balance;
  String? currency;

  GopayBalance({
    this.linked,
    this.accountStatus,
    this.balance,
    this.currency,
  });

  GopayBalance.fromJson(Map<String, dynamic> json) {
    linked = json['linked'];
    accountStatus = json['accountStatus'];
    balance = json['balance'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['linked'] = linked;
    data['accountStatus'] = accountStatus;
    data['balance'] = balance;
    data['currency'] = currency;
    return data;
  }
}
