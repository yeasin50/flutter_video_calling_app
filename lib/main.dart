import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'provider/call_duration.dart';
import 'provider/dummy_data.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/call_page.dart';
import 'screens/chat_screen/chatting_screen.dart';
import 'screens/conversationsScreen/chats_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();
  await Permission.microphone.request();

  runApp(MyApp());
}

///TODO:: status bar color, backgound
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // StreamProvider<List<Message>>.value(
        //   value: MessageProvider().streamMessages(),
        //   initialData: [],
        // ),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CallProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter WebRTC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CallPage(),
        routes: routes,
      ),
    );
  }

  /// number of screens
  get routes {
    return {
      AuthScreen.routeName: (_) => AuthScreen(),
      ConversationListScreen.routeName: (_) => ConversationListScreen(),
      ChattingScreen.routeName: (_) => ChattingScreen(),
    };
  }
}
