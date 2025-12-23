class SavedAddress {
  int? id;
  int? userId;
  String? addressName;
  String? addressTitle;
  String? addressDetail;
  String? latitude;
  String? longitude;
  int? addressType;
  int? isDelete;
  int? createTime;
  int? updateTime;

  SavedAddress({
    this.id,
    this.userId,
    this.addressName,
    this.addressTitle,
    this.addressDetail,
    this.latitude,
    this.longitude,
    this.addressType,
    this.isDelete,
    this.createTime,
    this.updateTime,
  });

  SavedAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    addressName = json['addressName'];
    addressTitle = json['addressTitle'];
    addressDetail = json['addressDetail'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    addressType = json['addressType'];
    isDelete = json['isDelete'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['addressName'] = this.addressName;
    data['addressTitle'] = this.addressTitle;
    data['addressDetail'] = this.addressDetail;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['addressType'] = this.addressType;
    data['isDelete'] = this.isDelete;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    return data;
  }
}
