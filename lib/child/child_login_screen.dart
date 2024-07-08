// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safewomen/child/bottom_page.dart';
import 'package:safewomen/child/forgot_password_page.dart';
import 'package:safewomen/components/SecondaryButton.dart';
import 'package:safewomen/components/custom_textfield.dart';
import 'package:safewomen/child/register_child.dart';
import 'package:safewomen/db/share_pref.dart';
import 'package:safewomen/child/bottom_screens/child_home_page.dart';
import 'package:safewomen/parent/parent_home_screen.dart';
import 'package:safewomen/parent/parent_register_screen.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:safewomen/utils/constants.dart';
import 'package:safewomen/widgets/home_widgets/safehome/SafeHome.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //const LoginScreen({super.key});

  TextEditingController passwordC = TextEditingController();

  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit() async {
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _formData['email'].toString(),
              password: _formData['password'].toString());
      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
          Fluttertoast.showToast(msg: 'Login successful');
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then(
          (value) {
            if (value['type'] == 'parent') {
              print(value['type']);
              MySharedPrefference.saveUserType('parent');
              //goTo(context, ParentHomeScreen());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ParentHomeScreen()),
              );
            } else {
              MySharedPrefference.saveUserType('child');
              //goTo(context, BottomPage());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BottomPage()),
              );
            }
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        dialogueBox(context, "Warning", 'No user found for that email.', "Ok");
        print('No user found for that email.');
        passwordC.clear();
      } else if (e.code == 'wrong-password') {
        dialogueBox(
            context, "Warning", 'Wrong password provided for that user.', "Ok");
        print('Wrong password provided for that user.');
        passwordC.clear();
      }
    }
    print(_formData['email']);
    print(_formData['password']);
  }

  List logoName = ["उन्मुक्त", "UnMukta", "উন্মুক্ত"];

  Timer? timer;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   timer = Timer.periodic(
  //       Duration(milliseconds: 1500), (Timer t) => logo_animation());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: isLoading
          ? Center(child: progressIndicator(context))
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        logoName[0],
                        style: TextStyle(
                          fontSize: 40,
                          letterSpacing: 2.5,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //
                      //
                      //
                      //Sign in form
                      Responsive(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              //
                              //
                              //
                              //email field
                              //
                              //
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
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.2),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
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
                              //
                              ///end email field
                              //
                              ///
                              /////
                              ///
                              ///passwordfield
                              ////
                              ///
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                obscureText: isPasswordShown,
                                style: const TextStyle(
                                    fontSize: 15, letterSpacing: 1.5),
                                textInputAction: TextInputAction.done,
                                onSaved: (password) {
                                  _formData['password'] = password ?? "";
                                },
                                validator: (password) {
                                  if (password!.isEmpty) {
                                    return "Please enter a password";
                                  } else if (password.length < 7) {
                                    return "Password length should be greater than eight";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: passwordC,
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
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.2),
                                  suffixIcon: passwordC.text.isNotEmpty
                                      ? IconButton(
                                          icon: isPasswordShown
                                              ? Container(
                                                  width: 40,
                                                  height: 40,
                                                  margin: const EdgeInsets.only(
                                                      right: 2),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: const Center(
                                                      child: Icon(
                                                    Icons
                                                        .visibility_off_outlined,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )),
                                                )
                                              : Container(
                                                  width: 40,
                                                  height: 40,
                                                  margin: const EdgeInsets.only(
                                                      right: 2),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: const Center(
                                                      child: Icon(
                                                    Icons.visibility_outlined,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )),
                                                ),
                                          onPressed: () {
                                            setState(() {
                                              isPasswordShown =
                                                  !isPasswordShown;
                                            });
                                          },
                                        )
                                      : null,

                                  prefixIcon: Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                        child: Icon(
                                      Icons.vpn_key_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    )),
                                  ),
                                  // fillColor:
                                  //     const Color.fromARGB(15, 0, 0, 0),
                                  hintText: 'Enter your password',
                                ),
                              ),

                              ////
                              ///end passfield
                              ///
                              ///
                              ///
                              ///forgot password
                              ///
                              ///
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  goTo(context, ForgotPassword());
                                },
                                child: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 8.0, bottom: 10),
                                    child: Text(
                                      'Forgot Password ?',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              ////
                              ///end forgot password
                              ///
                              ///
                              ///
                              ///login button
                              ///
                              ///
                              ///
                              PrimaryButton(
                                title: 'Login',
                                onPressed: () {
                                  //progressIndicator(context);
                                  if (_formKey.currentState!.validate()) {
                                    _onSubmit();
                                  }
                                },
                              ),

                              ///
                              ///
                              ///end login b
                              ///
                              ///
                            ],
                          ),
                        ),
                      ),

                      ///
                      ///
                      ///end form
                      ///
                      ///
                      ///
                      ///
                      SizedBox(
                        height: 20,
                      ),
                      Responsive(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                goTo(context, RegisterChildScreen());
                              },
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 8.0, bottom: 10),
                                  child: Text(
                                    'Register as Child',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      letterSpacing: 1.5,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                goTo(
                                  context,
                                  RegisterParentScreen(),
                                );
                              },
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 8.0, bottom: 10),
                                  child: Text(
                                    'Register as Parent',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      letterSpacing: 1.5,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
