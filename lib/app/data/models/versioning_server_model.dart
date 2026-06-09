class VersioningServer {
  int? id;
  String? url;
  String? content;
  int? mandatory;
  String? version;
  String? googlePlayLink;
  String? appleStoreLink;

  VersioningServer({
    this.id,
    this.url,
    this.content,
    this.mandatory,
    this.version,
    this.googlePlayLink,
    this.appleStoreLink,
  });

  VersioningServer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    content = json['content'];
    mandatory = json['mandatory'];
    version = json['version'];
    googlePlayLink = json['googlePlayLink'];
    appleStoreLink = json['appleStoreLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['content'] = this.content;
    data['mandatory'] = this.mandatory;
    data['version'] = this.version;
    data['googlePlayLink'] = this.googlePlayLink;
    data['appleStoreLink'] = this.appleStoreLink;
    return data;
  }
}
