import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_rtc/components/round_icon.dart';
import 'package:web_rtc/screens/conversationsScreen/components/custom_logo.dart';

import 'widgets/action_buttons.dart';

class VideoCallBody extends StatefulWidget {
  const VideoCallBody({
    Key? key,
  }) : super(key: key);

  @override
  _VideoCallBodyState createState() => _VideoCallBodyState();
}

class _VideoCallBodyState extends State<VideoCallBody> {
  bool _hideCaller = false;

  String _receiverName = "Amigo as Amo";
  String _avatarUrl = 'assets/images/yeasin.jpg';

  double _callerViewHeight = 100;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _callerViewHeight = constraints.maxWidth * .3;
      return Stack(
        children: [
          ///temp background
          Container(
            color: Colors.green.withOpacity(.4),
          ),

          ///`receiver`
          ///Logo + Name
          buildReceiverLogoName(),

          ///`Caller/myPreview`
          callerPreview(),

          ///`action buttons`
          CallActionButtons(),
        ],
      );
    });
  }

  Align buildReceiverLogoName() {
    final TextStyle _nameStyle = GoogleFonts.lato(
      color: Colors.black.withOpacity(.8),
      fontWeight: FontWeight.w400,
    );
    return Align(
      alignment: Alignment(-.96, -.95),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomLogo(
            child: Image.asset(
              _avatarUrl,
              fit: BoxFit.cover,
            ),
            isBorder: true,
          ),
          Text(
            _receiverName,
            style: _nameStyle,
          ),
        ],
      ),
    );
  }

  Align callerPreview() {
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.all(1),
            onPressed: () {
              setState(() {
                _hideCaller = !_hideCaller;
              });
            },
            icon: Icon(
              _hideCaller ? Icons.navigate_before : Icons.navigate_next,
              color: Colors.white,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            color: Colors.yellow,
            width: _hideCaller ? 0.0 : _callerViewHeight,
            height: _hideCaller ? 0.0 : _callerViewHeight * 1.4,
            child: Text("Container here"),
          ),
        ],
      ),
    );
  }
}
