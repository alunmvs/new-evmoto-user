class LoginData {
  int? id;
  String? token;
  String? appid;
  String? emergencyContact;
  String? emergencyContactNumber;
  int? isBind;

  LoginData({
    this.id,
    this.token,
    this.appid,
    this.emergencyContact,
    this.emergencyContactNumber,
    this.isBind,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    appid = json['appid'];
    emergencyContact = json['emergencyContact'];
    emergencyContactNumber = json['emergencyContactNumber'];
    isBind = json['isBind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['appid'] = this.appid;
    data['emergencyContact'] = this.emergencyContact;
    data['emergencyContactNumber'] = this.emergencyContactNumber;
    data['isBind'] = this.isBind;
    return data;
  }
}
