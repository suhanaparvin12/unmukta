import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safewomen/child/child_login_screen.dart';
import 'package:safewomen/components/PrimaryButton.dart';
import 'package:safewomen/components/SecondaryButton.dart';
import 'package:safewomen/components/custom_textfield.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:safewomen/utils/constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ///
  ///
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  //onsubmit function
  _onSubmit() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: progressIndicator(context),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      // ignore: use_build_context_synchronously
      // dialogueBox(context, 'Sucess',
      //     'Reset password link has been sent to your provided email.');
      // ignore: use_build_context_synchronously
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: const Text(
              'Sucess',
              textAlign: TextAlign.left,
            ),
            actions: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reset password link has been sent to your provided email.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                  title: 'OK',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  })
            ],
          ),
        ),
      );
      //Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      //Fluttertoast.showToast(msg: e.message.toString());
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: const Text(
              'Warning',
              textAlign: TextAlign.left,
            ),
            actions: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  e.message.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                  title: 'OK',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  })
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:
                Theme.of(context).colorScheme.surfaceVariant,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: isLoading
          ? progressIndicator(context)
          : SafeArea(
              child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            borderRadius: BorderRadius.circular(20)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'FORGOT PASSWORD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.5,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.vpn_key,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        size: 80,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Change your Password by email reset link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Responsive(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: const TextStyle(
                                  fontSize: 15, letterSpacing: 1.5),
                              textCapitalization: TextCapitalization.none,
                              maxLines: 1,
                              autofocus: false,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withOpacity(0.2),
                                      width: 2,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withOpacity(0.5),
                                      width: 2.5,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                      width: 2,
                                    )),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                      width: 2.5,
                                    )),
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(22),
                                filled: true,
                                hintText: 'Enter your email',
                                prefixIcon: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Center(
                                      child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                                ),
                                suffixIcon: emailController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Container(
                                          width: 40,
                                          height: 40,
                                          margin:
                                              const EdgeInsets.only(right: 2),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: const Center(
                                              child: Icon(
                                            Icons.clear_outlined,
                                            color: Colors.white,
                                            size: 20,
                                          )),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            emailController.clear();
                                          });
                                        },
                                      )
                                    : null,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.2),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              validator: (email) {
                                if (email!.isEmpty) {
                                  return "Please enter a email";
                                } else if (email.length < 3 ||
                                    !email.contains('@')) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                              onSaved: (email) {
                                _formData['email'] = email ?? "";
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            PrimaryButton(
                                title: 'Reset Password',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _onSubmit();
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )),
    );
    ;
  }
}
