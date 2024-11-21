import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_logo.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///`user logo`
            CustomLogo(
              child: Image.asset(
                'assets/images/yeasin.jpg',
                fit: BoxFit.cover,
              ),
              isBorder: true,
            ),
            buildChattext(context),
            newConversationButton(),
          ],
        ),
      );
    });
  }

  Expanded newConversationButton() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomLogo(
            child: Icon(
              Icons.create,
              color: Colors.black,
            ),
            bgColor: Colors.grey.withOpacity(.5),
            width: 40,
            isBorder: false,
            onClick: () {
              print("new chat");
            },
          )
        ],
      ),
    );
  }

  Padding buildChattext(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        "Chats",
        textAlign: TextAlign.center,
        style: GoogleFonts.acme(
          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
