class GopayLinkStatus {
  bool? linked;
  String? accountStatus;
  int? status;
  String? phoneNumber;

  GopayLinkStatus({
    this.linked,
    this.accountStatus,
    this.status,
    this.phoneNumber,
  });

  GopayLinkStatus.fromJson(Map<String, dynamic> json) {
    linked = json['linked'];
    accountStatus = json['accountStatus'];
    status = json['status'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['linked'] = linked;
    data['accountStatus'] = accountStatus;
    data['status'] = status;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
