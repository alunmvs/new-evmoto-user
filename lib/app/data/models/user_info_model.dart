class UserInfo {
  int? id;
  String? name;
  String? nickName;
  String? phone;
  String? email;
  String? lastName;
  String? firstName;
  int? isAuth;
  int? verified;
  String? avatar;
  int? sex;
  String? birthday;
  int? integral;
  double? balance;
  int? language;
  String? emergencyContact;
  String? emergencyContactNumber;

  UserInfo({
    this.id,
    this.name,
    this.nickName,
    this.phone,
    this.email,
    this.lastName,
    this.firstName,
    this.isAuth,
    this.verified,
    this.avatar,
    this.sex,
    this.birthday,
    this.integral,
    this.balance,
    this.language,
    this.emergencyContact,
    this.emergencyContactNumber,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nickName = json['nickName'];
    phone = json['phone'];
    email = json['email'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    isAuth = json['isAuth'];
    verified = json['verified'];
    avatar = json['avatar'];
    sex = json['sex'];
    birthday = json['birthday'];
    integral = json['integral'];
    balance = json['balance'];
    language = json['language'];
    emergencyContact = json['emergencyContact'];
    emergencyContactNumber = json['emergencyContactNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nickName'] = this.nickName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['isAuth'] = this.isAuth;
    data['verified'] = this.verified;
    data['avatar'] = this.avatar;
    data['sex'] = this.sex;
    data['birthday'] = this.birthday;
    data['integral'] = this.integral;
    data['balance'] = this.balance;
    data['language'] = this.language;
    data['emergencyContact'] = this.emergencyContact;
    data['emergencyContactNumber'] = this.emergencyContactNumber;
    return data;
  }
}
