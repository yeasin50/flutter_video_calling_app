import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_rtc/components/rounded_button.dart';
import 'package:web_rtc/components/round_icon.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:web_rtc/screens/conversationsScreen/chats_screen.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin {
  bool isLogin = true;
  bool _onAlreadyAccTapped = false;
  bool _passVisibility = true;
  bool _confPassVisibility = true;

  ///`dummy userName, password`
  late var _mail = "";
  var _pass = '';
  var _confPass = '';
  final _formKey = GlobalKey<FormState>();

  final textFieldContainerDecoration = BoxDecoration(
      border: Border.all(
        width: 3,
        color: Colors.pink,

        ///later gradient
      ),
      borderRadius: BorderRadius.circular(20));

  late AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  /// switch between logIn and SignUp
  _switchLogin() {
    if (isLogin) {
      setState(() => isLogin = false);
      _controller.forward();
    } else {
      _controller.reverse();

      ///`must: animation duration < controller duration`
      Timer(
          const Duration(milliseconds: 200),
          () => _animation.addListener(() => SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                if (_animation.isDismissed) setState(() => isLogin = true);
              })));
    }
  }

  _verifyUser() {
    ///`validate form`
    ///TODO:: validate more
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      _formKey.currentState!.save();
      print("mail: $_mail");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
      Navigator.pushReplacementNamed(context, ConversationListScreen.routeName);
    }
  }

  ///todo:: i can use constraints and everyone size, then i'll able to set animation size :()
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          title(context),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              // height: constraints.maxHeight * .47,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    emailTextField(),
                    passwordTextField(),
                    if (!isLogin) confPasswordTextField(),
                    loginORsignupButton(),
                    orDivider(),
                    alreadyHaveanAccount(),
                    SizedBox(
                      height: 10,
                    ),
                    // socialIcons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget alreadyHaveanAccount() {
    return Align(
      alignment: Alignment(0, .81),
      child: GestureDetector(
        onTapDown: (details) {
          setState(() => _onAlreadyAccTapped = true);
        },
        onTapUp: (_) => setState(() => _onAlreadyAccTapped = false),
        onTap: _switchLogin,
        child: EasyRichText(
          isLogin ? "Don't have an Account? Sign up" : "Already have an Account? Login",
          defaultStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.white.withOpacity(.8),
              backgroundColor: _onAlreadyAccTapped ? Colors.white.withOpacity(.5) : Colors.transparent,
            ),
          ),
          patternList: [
            EasyRichTextPattern(
              targetString: "Sign up",
              style: GoogleFonts.cabin(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            EasyRichTextPattern(
              targetString: "Login",
              style: GoogleFonts.cabin(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding loginORsignupButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedButton(
        labelText: isLogin ? "login" : "Signup",
        onPress: () {
          _verifyUser();
        },
      ),
    );
  }

  Widget socialIcons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RoundIcon(
            child: Icon(
              Icons.ac_unit,
              size: 44,
            ),
            press: () {
              print("clicked");
            },
            label: "facebook",
          ),
          RoundIcon(
            child: Icon(
              Icons.access_alarm,
              size: 44,
            ),
            press: () {
              print("clicked2");
            },
            label: "Google",
          ),
          RoundIcon(
            child: Icon(
              Icons.celebration,
              size: 44,
            ),
            press: () {
              print("clicked3");
            },
            label: "Twitter",
          ),
        ],
      ),
    );
  }

  LayoutBuilder orDivider() {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDivider(),
            // buildProgressDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "OR",
                style: GoogleFonts.cabin(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            buildDivider(),
            // Expanded(
            //   child: RotatedBox(
            //     quarterTurns: 2,
            //     child: buildProgressDivider(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Expanded buildProgressDivider() {
    return Expanded(
        child: LinearProgressIndicator(
      backgroundColor: Colors.red,
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.white,
      ),
    ));
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        height: 2,
        color: Colors.red,
      ),
    );
  }

  InputDecoration inputDecoration(
    String hint,
    IconData prefix,
  ) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(12),
      labelText: hint,
      labelStyle: TextStyle(
        color: Colors.white.withOpacity(.7),
      ),
      prefixIcon: Icon(
        prefix,
        color: Colors.white,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(
          color: Colors.green,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    );
  }

  /// maybe separete 2 coz we wanna implement animation
  Widget passwordTextField() {
    final String _hint = "Password";
    InputDecoration _decoration = inputDecoration(
      _hint,
      Icons.ac_unit,
    );

    _decoration = _decoration.copyWith(
      suffix: GestureDetector(
        onTap: () => setState(
          () => _passVisibility = !_passVisibility,
        ),
        child: Icon(
          _passVisibility ? Icons.visibility : Icons.visibility_off_rounded,
          color: Colors.white.withOpacity(.8),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onSaved: (newValue) => _pass = newValue!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          } else if (value.length < 4) {
            return "minimum 4 characters";
          }
          return null;
        },
        obscureText: _passVisibility ? true : false,
        cursorColor: Colors.green,
        key: ValueKey(_hint),
        decoration: _decoration,
      ),
    );
  }

  ScaleTransition confPasswordTextField() {
    final String _hint = "Confirm Password";
    InputDecoration _decoration = inputDecoration(
      _hint,
      Icons.ac_unit,
    );

    _decoration = _decoration.copyWith(
      suffix: GestureDetector(
        onTap: () => setState(
          () => _confPassVisibility = !_confPassVisibility,
        ),
        child: Icon(
          _confPassVisibility ? Icons.visibility : Icons.visibility_off_rounded,
          color: Colors.white.withOpacity(.8),
        ),
      ),
    );

    return ScaleTransition(
      scale: _controller,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onSaved: (newValue) => _confPass = newValue!,
          validator: (value) {
            if (isLogin)
              return null;
            else if (value == null || value.isEmpty) {
              return 'Please Retype your password';
            } else if (value.length < 4) {
              return "minimum 4 characters";
            }
            return null;
          },
          obscureText: _confPassVisibility ? true : false,
          cursorColor: Colors.green,
          key: ValueKey(_hint),
          decoration: _decoration,
        ),
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        cursorColor: Colors.green,
        onSaved: (newValue) => _mail = newValue!,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!value.contains("@")) return "invalid email";
          return null;
        },
        key: ValueKey('email'),
        decoration: inputDecoration(
          "Email",
          Icons.email,
        ),
      ),
    );
  }

  Widget title(BuildContext context) {
    return Align(
      alignment: Alignment(0, -.7),
      child: Text(
        isLogin ? "Login" : "Sign up",
        style: GoogleFonts.aladin(
            letterSpacing: 5,
            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            fontWeight: FontWeight.w600,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(8.0, 8.0),
                blurRadius: 3.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              Shadow(
                offset: Offset(6.0, 6.0),
                blurRadius: 8.0,
                color: Color.fromARGB(125, 0, 0, 255),
              ),
            ],
            color: Colors.white),
      ),
    );
  }
}
