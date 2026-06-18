class DispatchPopupActive {
  String? notificationType;
  String? method;
  int? orderId;
  int? orderType;
  int? active;
  int? waitTime;
  int? attempt;
  int? maxAttempts;

  DispatchPopupActive({
    this.notificationType,
    this.method,
    this.orderId,
    this.orderType,
    this.active,
    this.waitTime,
    this.attempt,
    this.maxAttempts,
  });

  DispatchPopupActive.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];
    method = json['method'];
    orderId = _toInt(json['orderId']);
    orderType = _toInt(json['orderType']);
    active = _toInt(json['active']);
    waitTime = _toInt(json['waitTime']);
    attempt = _toInt(json['attempt']);
    maxAttempts = _toInt(json['maxAttempts']);
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_type'] = notificationType;
    data['method'] = method;
    data['orderId'] = orderId;
    data['orderType'] = orderType;
    data['active'] = active;
    data['waitTime'] = waitTime;
    data['attempt'] = attempt;
    data['maxAttempts'] = maxAttempts;
    return data;
  }
}
