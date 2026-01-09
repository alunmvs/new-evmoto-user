class EvmotoOrderChatCalls {
  int? calleeId;
  String? calleeAvatar;
  String? calleeName;
  String? calleeType;
  String? calleeSdp;
  int? callerId;
  String? callerAvatar;
  String? callerName;
  String? callerType;
  String? callerSdp;
  DateTime? answeredAt;
  DateTime? createdAt;
  String? evmotoOrderChatParticipantsDocumentId;
  String? callEndedBy;
  DateTime? callEndedAt;

  EvmotoOrderChatCalls({
    this.calleeId,
    this.calleeAvatar,
    this.calleeName,
    this.calleeType,
    this.calleeSdp,
    this.callerId,
    this.callerAvatar,
    this.callerName,
    this.callerType,
    this.callerSdp,
    this.answeredAt,
    this.createdAt,
    this.evmotoOrderChatParticipantsDocumentId,
    this.callEndedBy,
    this.callEndedAt,
  });

  EvmotoOrderChatCalls.fromJson(Map<String, dynamic> json) {
    calleeId = json['calleeId'];
    calleeAvatar = json['calleeAvatar'];
    calleeName = json['calleeName'];
    calleeType = json['calleeType'];
    calleeSdp = json['calleeSdp'];
    callerId = json['callerId'];
    callerAvatar = json['callerAvatar'];
    callerName = json['callerName'];
    callerType = json['callerType'];
    callerSdp = json['callerSdp'];
    if (json['answeredAt'] != null) {
      answeredAt = json['answeredAt'].toDate();
    }
    if (json['createdAt'] != null) {
      createdAt = json['createdAt'].toDate();
    }
    evmotoOrderChatParticipantsDocumentId =
        json['evmotoOrderChatParticipantsDocumentId'];
    callEndedBy = json['callEndedBy'];
    if (json['callEndedAt'] != null) {
      callEndedAt = json['callEndedAt'].toDate();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calleeId'] = this.calleeId;
    data['calleeAvatar'] = this.calleeAvatar;
    data['calleeName'] = this.calleeName;
    data['calleeType'] = this.calleeType;
    data['calleeSdp'] = this.calleeSdp;
    data['callerId'] = this.callerId;
    data['callerAvatar'] = this.callerAvatar;
    data['callerName'] = this.callerName;
    data['callerType'] = this.callerType;
    data['callerSdp'] = this.callerSdp;
    data['answeredAt'] = this.answeredAt;
    data['createdAt'] = this.createdAt;
    data['evmotoOrderChatParticipantsDocumentId'] =
        this.evmotoOrderChatParticipantsDocumentId;
    data['callEndedBy'] = this.callEndedBy;
    data['callEndedAt'] = this.callEndedAt;
    return data;
  }
}
