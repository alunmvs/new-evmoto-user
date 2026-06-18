class DispatchExpired {
  String? notificationType;
  String? method;
  int? orderId;
  int? orderType;
  int? expired;
  int? hadPopup;
  int? popupCount;

  DispatchExpired({
    this.notificationType,
    this.method,
    this.orderId,
    this.orderType,
    this.expired,
    this.hadPopup,
    this.popupCount,
  });

  DispatchExpired.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];
    method = json['method'];
    orderId = _toInt(json['orderId']);
    orderType = _toInt(json['orderType']);
    expired = _toInt(json['expired']);
    hadPopup = _toInt(json['hadPopup']);
    popupCount = _toInt(json['popupCount']);
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
    data['expired'] = expired;
    data['hadPopup'] = hadPopup;
    data['popupCount'] = popupCount;
    return data;
  }
}
