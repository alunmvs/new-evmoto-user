class Advertisement {
  int? id;
  String? name;
  String? imgUrl;
  int? type;
  int? isJump;
  int? jumpType;
  String? jumpUrl;
  String? content;
  int? sortNum;

  Advertisement({
    this.id,
    this.name,
    this.imgUrl,
    this.type,
    this.isJump,
    this.jumpType,
    this.jumpUrl,
    this.content,
    this.sortNum,
  });

  Advertisement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imgUrl = json['imgUrl'];
    type = json['type'];
    isJump = json['isJump'];
    jumpType = json['jumpType'];
    jumpUrl = json['jumpUrl'];
    content = json['content'];
    sortNum = json['sortNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['imgUrl'] = this.imgUrl;
    data['type'] = this.type;
    data['isJump'] = this.isJump;
    data['jumpType'] = this.jumpType;
    data['jumpUrl'] = this.jumpUrl;
    data['content'] = this.content;
    data['sortNum'] = this.sortNum;
    return data;
  }
}
