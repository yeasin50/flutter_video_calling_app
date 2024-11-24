import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../src/infrastructure/call_repo.dart';

///*  A sample example performing video call through webRTC
///
///`How call works`
/// Check out signaling
///
class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final CallConnectionRepo callRepo = CallConnectionRepo();

  bool _isCaller = true;

  final sdpController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    sdpController.dispose();
    callRepo.dispose();
    super.dispose();
  }

  bool isFrontCamera = true;

  Map<String, dynamic>? offerData;
  void _createOfferAndCopy() async {
    offerData = _isCaller ? await callRepo.makeOffer() : await callRepo.createAnswer();
    await Clipboard.setData(ClipboardData(text: jsonEncode(offerData)));
  }

  void onPaste() async {
    final text = await Clipboard.getData("text/plain");
    sdpController.text = text?.text ?? "";
  }

  void setDescription() async {
    await callRepo.setRemoteDescription(
      sdpController.text,
      isOffer: _isCaller,
    );
  }

  final candidateController = TextEditingController();

  void connectInit() async {
    if (candidateController.text.trim().isEmpty) {
      debugPrint("connect first.. get offer[createAnswer] ");
      return;
    }
    final result = await callRepo.connectCall(candidateController.text.trim());
    print(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final descriptionInput = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24),
        TextButton(
          onPressed: onPaste,
          child: Text("Paste from ClipBoard |2"),
        ),
        TextField(
          controller: sdpController,
          decoration: InputDecoration(border: OutlineInputBorder()),
          maxLength: TextField.noMaxLength,
        ),
        OutlinedButton(
          onPressed: setDescription,
          child: Text("set Remote Desc"),
        ),
        const SizedBox(height: 24),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: Text("WebRTC Video call test")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            //todo: add notes of signaling
            SegmentedButton(
              segments: [
                ButtonSegment(value: true, label: Text("Caller")),
                ButtonSegment(value: false, label: Text("Receiver")),
              ],
              selected: {_isCaller},
              onSelectionChanged: (p0) {
                _isCaller = p0.first;
                setState(() {});
              },
            ),

            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                      child: RTCVideoView(
                        callRepo.localRender,
                        mirror: true,
                        placeholderBuilder: (context) => Center(child: Text("Loading...")),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                      child: RTCVideoView(
                        callRepo.remoteRender,
                        mirror: true,
                        placeholderBuilder: (context) => Center(child: Text("Loading...")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!_isCaller) descriptionInput,

            ElevatedButton(
              onPressed: _createOfferAndCopy,
              child: Text("create ${_isCaller ? "Offer" : "answer"} and copy on ClipBoard"),
            ),

            if (_isCaller) descriptionInput,
            const SizedBox(height: 24),
            // if (_isCaller)
            ...[
              TextFormField(
                controller: candidateController,
                decoration: InputDecoration(hintText: "candidate string"),
              ),
              FloatingActionButton.extended(
                onPressed: connectInit,
                label: Text("Connect call"),
              )
            ]
          ],
        ),
      ),
    );
  }
}
