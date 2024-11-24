import 'package:flutter/material.dart';
import 'package:web_rtc/components/round_icon.dart';

class CallActionButtons extends StatefulWidget {
  @override
  _CallActionButtonsState createState() => _CallActionButtonsState();
}

class _CallActionButtonsState extends State<CallActionButtons> {
  bool _micOn = true;
  bool _camOn = true;
  double iconSize = 30;

  _handleMic() {
    setState(() {
      _micOn = !_micOn;
    });
  }

  _handleCam() {
    setState(() {
      _camOn = !_camOn;
    });
  }

  _hangUP() {}

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, .9),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: "Turn off/on your camera",
            child: RoundIcon(
              background: Colors.black.withOpacity(.4),
              child: Icon(
                _camOn ? Icons.videocam_off : Icons.videocam,
                color: Colors.white,
                size: iconSize,
              ),
              press: _handleCam,
              // label: "Camera",
            ),
          ),
          Tooltip(
            message: "Hang UP",
            child: RoundIcon(
              background: Colors.red,
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: iconSize,
              ),
              press: _hangUP,
              // label: "Call End",
            ),
          ),
          Tooltip(
            message: 'Microphone On/Off',
            child: RoundIcon(
              background: Colors.black.withOpacity(.4),
              child: Icon(
                _micOn ? Icons.mic_off : Icons.mic_rounded,
                color: Colors.white,
                size: iconSize,
              ),
              press: _handleMic,
              // label: "Mute",
            ),
          ),
        ],
      ),
    );
  }
}
