import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _localRenderer = new RTCVideoRenderer();
  MediaStream? _localStream;
  bool _offer = false;

  late RTCPeerConnection _peerConnection;

  ///second person
  final _remoteRenderer = new RTCVideoRenderer();

  final sdpController = TextEditingController();

  final Map<String, dynamic> mediaConstraints = {
    'audio': true,
    'video': {
      /// `Provide your own width, height and frame rate here`
      /// if it's larger than your screen , it wount showUP
      'mandatory': {
        'minWidth': '200',
        'minHeight': '200',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    },
  };

  ///`for UX`
  ///after clicking offer button there will a generated offer credintial and
  ///this variable will hold that jsonText
  ///later it will use to paste button but wait we on diff page ,
  /// then make textBOX or just use exits textField and filled with generated sdp Jsontext
  /// instead of depending on consol we gonna print somewhere of debig purpose
  /// later we will pass this data over some media
  /// this is called signaling
  dynamic offerJsonString = null;

  @override
  void initState() {
    super.initState();
    initRenderers();

    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
  }

  _createPeerConnection() async {
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

    _localStream = await _getUserMedia();

    RTCPeerConnection pc = await createPeerConnection(config, offerSdpConstraints);

    pc.addStream(_localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
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

    return pc;
  }

  @override
  void dispose() {
    _localStream!.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  _getUserMedia() async {
    var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    // _localStream = stream;
    _localRenderer.srcObject = stream;
    return stream;
  }

  bool isFrontCamera = true;

  void switchCamera() async {
    if (_localStream != null) {
      bool value = await _localStream!.getVideoTracks()[0].switchCamera();
      while (value == this.isFrontCamera) value = await _localStream!.getVideoTracks()[0].switchCamera();
      this.isFrontCamera = value;
    }
  }

  // getUserMedia() async {
  //   var devices = await navigator.mediaDevices.getUserMedia(mediaConstraints);
  //   log("logs" + devices.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("WebRTC"),
        ),
        body: Center(
          child: Column(
            children: [
              videoRenderers(),
              offerAnswerButton(),
              autoCompletedButton(),
              sdpCandidateTF(),
              sdpCandidateButtons(),
              // RaisedButton(
              //   onPressed: switchCamera,
              //   child: Text("Switch Cam"),
              // )
            ],
          ),
        ));
  }

  SizedBox videoRenderers() => SizedBox(
        height: 200,
        child: Row(
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                // width: MediaQuery.of(context).size.width,
                // height: 400,
                child: RTCVideoView(_localRenderer, mirror: true),
                // child: Text("hey"),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                // width: MediaQuery.of(context).size.width,
                // height: 400,
                child: RTCVideoView(_remoteRenderer, mirror: true),
                // child: Text("hey"),
              ),
            ),
          ],
        ),
      );

  Widget offerAnswerButton() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: [
                ElevatedButton(
                  onPressed: _createOFfer,
                  child: Text("Offer"),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("1st click here")
              ],
            ),
            ElevatedButton(
              onPressed: _answer,
              child: Text("Answer"),
            ),
          ],
        ),
      );

  Padding sdpCandidateTF() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: sdpController,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          maxLength: TextField.noMaxLength,
        ),
      );

  Row sdpCandidateButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextButton(
            onPressed: _setRemodeDescription,
            child: Text("set Remote Desc"),
          ),
          TextButton(
            onPressed: _setCandiate,
            child: Text("set Candidate"),
          ),
        ],
      );

  /// `auto copyPaste creditial helper`
  Widget autoCompletedButton() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: [
                TextButton(
                  onPressed: _copyPasteSdp,
                  child: Text("Copy & paste"),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("2nd click here")
              ],
            ),
            Container(),
          ],
        ),
      );

  void _copyPasteSdp() {}

  ///`Offer Text copy and hold on Copy & paste`
  void _createOFfer() async {
    Map<String, dynamic> cfMap = {'offerToReceiveVideo': 1};
    RTCSessionDescription description = await _peerConnection.createOffer(cfMap);

    var session = parse(description.sdp!);
    // log("oFFer>> " + json.encode(session));

    print(json.encode(session));
    _offer = true;
    _peerConnection.setLocalDescription(description);
  }

  void _setRemodeDescription() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');

    String sdp = write(session, null);

    RTCSessionDescription description = new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

    print(description.toMap());

    await _peerConnection.setRemoteDescription(description);
  }

  void _answer() async {
    RTCSessionDescription description = await _peerConnection.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp!);
    print(json.encode(session));
    _peerConnection.setLocalDescription(description);
  }

  void _setCandiate() async {
    String jsonString = sdpController.text;

    dynamic session = await jsonDecode("$jsonString");
    print(session['candidate']);

    dynamic candidate = new RTCIceCandidate(session['candidate'], session['sdpMid'], session['sdpMlineIndex']);

    await _peerConnection.addCandidate(candidate);
  }
}
