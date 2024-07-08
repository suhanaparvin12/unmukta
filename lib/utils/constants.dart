import 'dart:ui';

import 'package:flutter/material.dart';

import '../components/PrimaryButton.dart';

Color primaryColor = Color(0xfffc3b77);

void goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ));
}

dialogueBox(
    BuildContext context, String title, String body, String button_text) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.left,
        ),
        actions: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              body,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          PrimaryButton(
            title: button_text,
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
    ),
  );
}

Widget progressIndicator(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.inversePrimary,
      // minHeight: 5,
      strokeWidth: 4,
    ),
    // child: BackdropFilter(
    //     filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
    //     child: LottieBuilder.asset(
    //       'assets/medbuddy_logo.json',
    //       height: 150,
    //       width: 150,
    //     )),
  );
}
