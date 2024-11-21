import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/call_duration.dart';
import '../conversationsScreen/components/custom_logo.dart';
import 'components_/action_buttons.dart';

class AudioCallBody extends StatefulWidget {
  @override
  _AudioCallBodyState createState() => _AudioCallBodyState();
}

class _AudioCallBodyState extends State<AudioCallBody> {
  ///TODO:: pass from Before -1 in constructor
  String _receiverName = "Amigo as Amo";
  String _avatarUrl = 'assets/images/yeasin.jpg';

  // _onStart() {
  //   Provider.of<CallProvider>(context, listen: false).onStart();
  // }

  // _onEnd() {
  //   Provider.of<CallProvider>(context, listen: false).onCallEnd();
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ///Logo + name+ status
        LayoutBuilder(
          builder: (context, constraints) => Align(
            alignment: Alignment(0, -.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomLogo(
                  child: Image.asset(
                    _avatarUrl,
                    fit: BoxFit.cover,
                  ),
                  isBorder: true,
                  width: constraints.maxWidth * .3,
                ),
                //name
                SizedBox(
                  height: 10,
                ),
                Text(
                  _receiverName,
                  style: GoogleFonts.adamina(
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                ///`Duration`
                buildDuration(context),
              ],
            ),
          ),
        ),

        ///`action buttons`
        CallActionButtons(),
      ],
    );
  }

  Container buildDuration(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Consumer<CallProvider>(
        builder: (context, value, child) => Text(
          value.strDuration,
          style: GoogleFonts.lateef(
            color: Colors.white.withOpacity(.9),
            fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            letterSpacing: 2,
            // height: 1.5,
            fontWeight: FontWeight.w800,
            // background: Paint()
            //   ..color = Colors.black26
            //   ..style = PaintingStyle.fill,
          ),
        ),
      ),
    );
  }
}
