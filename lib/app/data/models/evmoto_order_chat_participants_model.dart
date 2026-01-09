class EvmotoOrderChatParticipants {
  int? driverId;
  String? driverName;
  bool? driverIsOnline;
  DateTime? driverLastSeen;
  bool? driverIsOnChatScreen;
  DateTime? driverChatScreenLastSeen;
  DateTime? driverJoinedAt;
  int? userId;
  String? userName;
  bool? userIsOnline;
  DateTime? userLastSeen;
  bool? userIsOnChatScreen;
  DateTime? userChatScreenLastSeen;
  DateTime? userJoinedAt;

  EvmotoOrderChatParticipants({
    this.driverId,
    this.driverName,
    this.driverIsOnline,
    this.driverIsOnChatScreen,
    this.driverLastSeen,
    this.driverJoinedAt,
    this.userId,
    this.userName,
    this.userIsOnline,
    this.userIsOnChatScreen,
    this.userLastSeen,
    this.userJoinedAt,
  });

  EvmotoOrderChatParticipants.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    driverName = json['driverName'];
    driverIsOnline = json['driverIsOnline'];
    driverIsOnChatScreen = json['driverIsOnChatScreen'];
    if (json['driverLastSeen'] != null) {
      driverLastSeen = json['driverLastSeen'].toDate();
    }
    if (json['driverChatScreenLastSeen'] != null) {
      driverChatScreenLastSeen = json['driverChatScreenLastSeen'].toDate();
    }
    if (json['driverJoinedAt'] != null) {
      driverJoinedAt = json['driverJoinedAt'].toDate();
    }
    userId = json['userId'];
    userName = json['userName'];
    userIsOnline = json['userIsOnline'];
    userIsOnChatScreen = json['userIsOnChatScreen'];
    if (json['userLastSeen'] != null) {
      userLastSeen = json['userLastSeen'].toDate();
    }
    if (json['userChatScreenLastSeen'] != null) {
      userChatScreenLastSeen = json['userChatScreenLastSeen'].toDate();
    }
    if (json['userJoinedAt'] != null) {
      userJoinedAt = json['userJoinedAt'].toDate();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driverId'] = this.driverId;
    data['driverName'] = this.driverName;
    data['driverIsOnline'] = this.driverIsOnline;
    data['driverIsOnChatScreen'] = this.driverIsOnChatScreen;
    data['driverChatScreenLastSeen'] = this.driverChatScreenLastSeen;
    data['driverLastSeen'] = this.driverLastSeen;
    data['driverJoinedAt'] = this.driverJoinedAt;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userIsOnline'] = this.userIsOnline;
    data['userIsOnChatScreen'] = this.userIsOnChatScreen;
    data['userChatScreenLastSeen'] = this.userChatScreenLastSeen;
    data['userLastSeen'] = this.userLastSeen;
    data['userJoinedAt'] = this.userJoinedAt;
    return data;
  }
}
