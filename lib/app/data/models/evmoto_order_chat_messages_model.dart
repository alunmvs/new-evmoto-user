class EvmotoOrderChatMessages {
  String? evmotoOrderChatMessagesId;
  String? evmotoOrderChatParticipantsDocumentId;
  DateTime? createdAt;
  DateTime? sendAt;
  String? senderAttachmentUrl;
  String? senderId;
  String? senderMessage;
  String? senderType;
  bool? isRead;

  EvmotoOrderChatMessages({
    this.evmotoOrderChatMessagesId,
    this.evmotoOrderChatParticipantsDocumentId,
    this.createdAt,
    this.sendAt,
    this.senderAttachmentUrl,
    this.senderId,
    this.senderMessage,
    this.senderType,
    this.isRead,
  });

  EvmotoOrderChatMessages.fromJson(Map<String, dynamic> json) {
    evmotoOrderChatParticipantsDocumentId =
        json['evmotoOrderChatParticipantsDocumentId'];
    if (json['createdAt'] != null) {
      createdAt = json['createdAt'].toDate();
    }
    if (json['sendAt'] != null) {
      sendAt = json['sendAt'].toDate();
    }
    senderAttachmentUrl = json['senderAttachmentUrl'];
    senderId = json['senderId'].toString();
    senderMessage = json['senderMessage'];
    senderType = json['senderType'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['evmotoOrderChatParticipantsDocumentId'] =
        this.evmotoOrderChatParticipantsDocumentId;
    data['createdAt'] = this.createdAt;
    data['sendAt'] = this.sendAt;
    data['senderAttachmentUrl'] = this.senderAttachmentUrl;
    data['senderId'] = this.senderId;
    data['senderMessage'] = this.senderMessage;
    data['senderType'] = this.senderType;
    data['isRead'] = this.isRead;
    return data;
  }
}
