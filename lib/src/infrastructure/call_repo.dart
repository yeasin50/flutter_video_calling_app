import 'dart:convert';
import 'dart:developer';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

/// handle call-webRTC audio/video
class CallConnectionRepo {
  MediaStream? _localStream;

  final _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer get localRender => _localRenderer;

  final _remoteRenderer = RTCVideoRenderer();
  RTCVideoRenderer get remoteRender => _remoteRenderer;

  final Map<String, dynamic> mediaConstraints = {
    'audio': true,
    'video': {
      /// `Provide your own width, height and frame rate here`
      /// if it's larger than your screen , it won't showUP
      'mandatory': {
        'minWidth': '200',
        'minHeight': '200',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    },
  };

  void switchCamera() async {
    // if (_localStream != null) {
    //   bool value = await _localStream!.getVideoTracks()[0].switchCamera();
    //   while (value == this.isFrontCamera) value = await _localStream!.getVideoTracks()[0].switchCamera();
    //   this.isFrontCamera = value;
    // }
  }

  Future<RTCPeerConnection> connectionPeer() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    Map<String, dynamic> config = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    final userMediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = userMediaStream;
    _localStream = userMediaStream;

    RTCPeerConnection pc = await createPeerConnection(config, offerSdpConstraints);
    pc.addStream(_localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMLineIndex': e.sdpMLineIndex,
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print("addStream: " + stream.id);
      _remoteRenderer.srcObject = stream;
    };

    log("Created peer connection");

    return pc;
  }

  void dispose() async {
    _localStream?.dispose();
    _remoteRenderer.dispose();
    _localRenderer.dispose();
    await _pc?.dispose();
  }

  RTCPeerConnection? _pc;

  Future<Map<String, dynamic>?> makeOffer() async {
    _pc ??= await connectionPeer();
    final offer = await _pc!.createOffer({"offerToReceiveVideo": 1});
    final session = parse(offer.sdp!);
    await _pc!.setLocalDescription(offer);
    print(jsonEncode(session));
    return session;
  }

  Future<Map<String, dynamic>?> createAnswer() async {
    _pc ??= await connectionPeer();
    RTCSessionDescription description = await _pc!.createAnswer({"offerToReceiveVideo": 1});
    final session = parse(description.sdp!);
    _pc!.setLocalDescription(description);
    return session;
  }

  Future<void> setRemoteDescription(String sdpText, {required bool isOffer}) async {
    _pc ??= await connectionPeer();
    final session = await jsonDecode('$sdpText');
    String sdp = write(session, null);
    RTCSessionDescription rtcDesc = RTCSessionDescription(sdp, isOffer ? "answer" : "offer");
    await _pc!.setRemoteDescription(rtcDesc);
  }

  Future<String> connectCall(String candidateString) async {
    if (_pc == null) {
      return "uhu.. you've missed the steps ";
    }
    final session = jsonDecode(candidateString);

    final candidate = RTCIceCandidate(session['candidate'], session['sdpMid'], session['sdpMLineIndex']);
    await _pc!.addCandidate(candidate);
    return "Call connected";
  }
}
