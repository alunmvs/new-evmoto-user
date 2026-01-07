import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart' hide navigator;
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_calls_model.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class RideCallController extends GetxController {
  final UploadImageRepository uploadImageRepository;

  RideCallController({required this.uploadImageRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final rideOrderDetailController = Get.find<RideOrderDetailController>();

  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;

  final config = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ],
  };

  final callType = "caller".obs;
  final isCallAnswered = false.obs;
  final candidateAddedList = [].obs;
  final docsId = "".obs;

  final isMicrophoneOn = true.obs;
  final isSpeakerOn = false.obs;

  final evmotoOrderChatCalls = EvmotoOrderChatCalls().obs;

  final callStopWatchTimer = StopWatchTimer();

  final driverMediaRecorder = MediaRecorder();
  final driverMediaRecorderFilePath = "".obs;
  final userMediaRecorder = MediaRecorder();
  final userMediaRecorderFilePath = "".obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getLatestDocsIdByOrderId();

    await initRenderers();
    peerConnection = await createPeerConnection(config);
    await initLocalStream();

    peerConnection!.onIceCandidate = (candidate) async {
      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_calls')
          .doc(docsId.value)
          .update({
            'calleeIceCandidateList': FieldValue.arrayUnion([
              {
                'candidate': candidate.candidate,
                'sdpMid': candidate.sdpMid,
                'sdpMLineIndex': candidate.sdpMLineIndex,
              },
            ]),
          });
    };

    peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    peerConnection!.onSignalingState = (state) {};

    peerConnection!.onConnectionState = (state) async {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        if (Get.currentRoute == Routes.RIDE_CALL) {
          Get.back(result: true);
        }
      }
    };

    if (callType.value == "caller") {
      await onTapCall();
    } else if (callType.value == "callee") {
      await onTapAnswerCall();
    }

    await initListeners();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    await callStopWatchTimer.dispose();

    try {
      localStream?.getTracks().forEach((track) => track.stop());
    } catch (e) {}
    try {
      await peerConnection?.close();
    } catch (e) {}

    try {
      await localRenderer.dispose();
    } catch (e) {}
    try {
      await remoteRenderer.dispose();
    } catch (e) {}
  }

  Future<void> getLatestDocsIdByOrderId() async {
    var latestDocs = await FirebaseFirestore.instance
        .collection('evmoto_order_chat_calls')
        .where(
          'evmotoOrderChatParticipantsDocumentId',
          isEqualTo: rideOrderDetailController.orderRideDetail.value.orderId
              .toString(),
        )
        .orderBy('createdAt', descending: false)
        .get();

    if (latestDocs.docs.isEmpty == false) {
      if (latestDocs.docs.last.data()['calleeSdp'] != null) {
        callType.value = "caller";
      } else {
        docsId.value = latestDocs.docs.last.id;
        callType.value = "callee";
      }
    } else {
      callType.value = "caller";
    }
  }

  Future<void> initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<void> initListeners() async {
    FirebaseFirestore.instance
        .collection('evmoto_order_chat_calls')
        .doc(docsId.value)
        .snapshots()
        .listen((event) async {
          if (event.exists) {
            evmotoOrderChatCalls.value = EvmotoOrderChatCalls.fromJson(
              event.data()!,
            );
            if (callType.value == "caller") {
              if (isCallAnswered.value == false &&
                  event.data()?['calleeSdp'] != null) {
                isCallAnswered.value = true;
                await peerConnection?.setRemoteDescription(
                  RTCSessionDescription(event.data()!['calleeSdp'], 'answer'),
                );
                await Future.wait([
                  initDriverMediaRecorder(),
                  initUserMediaRecorder(),
                ]);
                callStopWatchTimer.onStartTimer();
                isCallAnswered.refresh();
              }

              if (event.data()?['calleeIceCandidateList'] != null) {
                for (var calleeIceCandidate
                    in event.data()?['calleeIceCandidateList']) {
                  if (candidateAddedList.contains(
                        calleeIceCandidate['candidate'],
                      ) ==
                      false) {
                    await peerConnection?.addCandidate(
                      RTCIceCandidate(
                        calleeIceCandidate['candidate'],
                        calleeIceCandidate['sdpMid'],
                        calleeIceCandidate['sdpMLineIndex'],
                      ),
                    );
                    candidateAddedList.add(calleeIceCandidate['candidate']);
                  }
                }
              }
            } else if (callType.value == "callee") {
              if (isCallAnswered.value == false &&
                  event.data()?['callerSdp'] != null) {
                isCallAnswered.value = true;
                await peerConnection?.setRemoteDescription(
                  RTCSessionDescription(event.data()!['callerSdp'], 'offer'),
                );

                RTCSessionDescription answer = await peerConnection!
                    .createAnswer();
                await peerConnection!.setLocalDescription(answer);

                await FirebaseFirestore.instance
                    .collection('evmoto_order_chat_calls')
                    .doc(docsId.value)
                    .set({'calleeSdp': answer.sdp}, SetOptions(merge: true));
                await Future.wait([
                  initDriverMediaRecorder(),
                  initUserMediaRecorder(),
                ]);
                callStopWatchTimer.onStartTimer();
                isCallAnswered.refresh();
              }

              if (event.data()?['callerIceCandidateList'] != null) {
                for (var callerIceCandidate
                    in event.data()?['callerIceCandidateList']) {
                  if (candidateAddedList.contains(
                        callerIceCandidate['candidate'],
                      ) ==
                      false) {
                    await peerConnection?.addCandidate(
                      RTCIceCandidate(
                        callerIceCandidate['candidate'],
                        callerIceCandidate['sdpMid'],
                        callerIceCandidate['sdpMLineIndex'],
                      ),
                    );
                    candidateAddedList.add(callerIceCandidate['candidate']);
                  }
                }
              }
            }

            if (evmotoOrderChatCalls.value.callEndedAt != null) {
              if (Get.currentRoute == Routes.RIDE_CALL) {
                Get.back(result: true);
              }
            }
          }
        });
  }

  Future<void> initLocalStream() async {
    localStream = await navigator.mediaDevices.getUserMedia({
      // 'video': {
      //   'facingMode': 'user',
      //   'width': 640,
      //   'height': 480,
      //   'frameRate': 30,
      // },
      'video': false,
      'audio': true,
    });

    localRenderer.srcObject = localStream;

    for (var track in localStream!.getTracks()) {
      await peerConnection!.addTrack(track, localStream!);
    }

    for (var track in localStream!.getAudioTracks()) {
      track.enabled = true;
    }
    await Helper.setSpeakerphoneOn(false);
  }

  Future<void> onTapAnswerCall() async {
    await FirebaseFirestore.instance
        .collection('evmoto_order_chat_calls')
        .doc(docsId.value)
        .set({
          "evmotoOrderChatParticipantsDocumentId": rideOrderDetailController
              .orderRideDetail
              .value
              .orderId
              .toString(),
          "calleeId": rideOrderDetailController.orderRideDetail.value.userId,
          "calleeName": rideOrderDetailController.orderRideDetail.value.user,
          "calleeAvatar":
              rideOrderDetailController.orderRideDetail.value.userHeadImg,
          "calleeType": "user",
          "answeredAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<void> onTapCall() async {
    var docRef = await FirebaseFirestore.instance
        .collection('evmoto_order_chat_calls')
        .add({
          "evmotoOrderChatParticipantsDocumentId": rideOrderDetailController
              .orderRideDetail
              .value
              .orderId
              .toString(),
          "callerId": rideOrderDetailController.orderRideDetail.value.driverId,
          "callerName":
              rideOrderDetailController.orderRideDetail.value.driverName,
          "callerAvatar":
              rideOrderDetailController.orderRideDetail.value.driverAvatar,
          "callerType": "driver",
          "createdAt": FieldValue.serverTimestamp(),
        });
    docsId.value = docRef.id;

    peerConnection!.onIceCandidate = (candidate) async {
      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_calls')
          .doc(docsId.value)
          .update({
            'callerIceCandidateList': FieldValue.arrayUnion([
              {
                'candidate': candidate.candidate,
                'sdpMid': candidate.sdpMid,
                'sdpMLineIndex': candidate.sdpMLineIndex,
              },
            ]),
          });
    };

    peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    var offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    await FirebaseFirestore.instance
        .collection('evmoto_order_chat_calls')
        .doc(docsId.value)
        .set({"callerSdp": offer.sdp}, SetOptions(merge: true));

    docsId.value = docRef.id;
  }

  Future<void> initDriverMediaRecorder() async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath =
        '${directory.path}/call_${rideOrderDetailController.orderId.value}_${docsId.value}_driver.mp4';

    await driverMediaRecorder.start(
      filePath,
      videoTrack: remoteRenderer.srcObject!.getVideoTracks().isEmpty
          ? null
          : remoteRenderer.srcObject!.getVideoTracks().first,
      audioChannel: RecorderAudioChannel.OUTPUT,
    );
  }

  Future<void> initUserMediaRecorder() async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath =
        '${directory.path}/call_${rideOrderDetailController.orderId.value}_${docsId.value}_user.mp4';

    await userMediaRecorder.start(
      filePath,
      videoTrack: localRenderer.srcObject!.getVideoTracks().isEmpty
          ? null
          : localRenderer.srcObject!.getVideoTracks().first,
      audioChannel: RecorderAudioChannel.INPUT,
    );
  }

  Future<void> stopUserMediaRecorder() async {
    await userMediaRecorder.stop();
  }

  Future<void> stopDriverMediaRecorder() async {
    await driverMediaRecorder.stop();
  }

  Future<void> stopAllMediaRecorder() async {
    await Future.wait([stopUserMediaRecorder(), stopDriverMediaRecorder()]);

    var directory = await getApplicationDocumentsDirectory();
    var outputFilePath =
        '${directory.path}/call_${rideOrderDetailController.orderId.value}_${docsId.value}.mp4';

    final command =
        '-i ${driverMediaRecorderFilePath.value} '
        '-i ${userMediaRecorderFilePath.value} '
        '-filter_complex amix=inputs=2:dropout_transition=0 '
        '-c:a aac -b:a 192k '
        '-y $outputFilePath';

    await FFmpegKit.execute(command);

    var callFileUrl = await uploadImageRepository.uploadCall(
      file: File(outputFilePath),
      fileName:
          'call_${rideOrderDetailController.orderId.value}_${docsId.value}_user.mp4',
    );
    await FirebaseFirestore.instance
        .collection('evmoto_order_chat_calls')
        .doc(docsId.value)
        .set({'user_call_file_url': callFileUrl}, SetOptions(merge: true));
  }
}
