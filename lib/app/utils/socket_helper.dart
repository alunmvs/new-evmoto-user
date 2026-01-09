import 'dart:convert';
import 'dart:typed_data';

Map<String, dynamic>? convertBytesToJson({required List<int> bytes}) {
  if (bytes.length < 4) return null;

  int payloadLength =
      (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];
  List<int> payloadBytes = bytes.sublist(4, 4 + payloadLength);
  String jsonString = utf8.decode(payloadBytes);
  Map<String, dynamic> jsonData = jsonDecode(jsonString);
  return jsonData;
}

Uint8List convertJsonToPacket(Map<String, dynamic> jsonData) {
  String jsonString = jsonEncode(jsonData);

  List<int> bodyBytes = utf8.encode(jsonString);

  int length = bodyBytes.length;

  Uint8List header = Uint8List(4);
  ByteData.view(header.buffer).setUint32(0, length, Endian.big);

  Uint8List packet = Uint8List(header.length + bodyBytes.length);
  packet.setRange(0, header.length, header);
  packet.setRange(header.length, packet.length, bodyBytes);

  return packet;
}
