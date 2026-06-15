class PaymentMethod {
  int? code;
  String? name;
  int? payManner;
  bool? enabled;
  String? remark;

  PaymentMethod({
    this.code,
    this.name,
    this.payManner,
    this.enabled,
    this.remark,
  });

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    payManner = json['payManner'];
    enabled = json['enabled'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['payManner'] = payManner;
    data['enabled'] = enabled;
    data['remark'] = remark;
    return data;
  }
}
