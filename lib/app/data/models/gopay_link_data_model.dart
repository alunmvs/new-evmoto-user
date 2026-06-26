class GopayLinkData {
  String? accountId;
  String? accountStatus;
  int? status;
  String? activationUrl;
  String? activationAppUrl;

  GopayLinkData({
    this.accountId,
    this.accountStatus,
    this.status,
    this.activationUrl,
    this.activationAppUrl,
  });

  GopayLinkData.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    accountStatus = json['accountStatus'];
    status = json['status'];
    activationUrl = json['activationUrl'];
    activationAppUrl = json['activationAppUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['accountStatus'] = accountStatus;
    data['status'] = status;
    data['activationUrl'] = activationUrl;
    data['activationAppUrl'] = activationAppUrl;
    return data;
  }
}
