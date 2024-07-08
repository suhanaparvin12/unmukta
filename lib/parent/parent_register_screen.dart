import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safewomen/components/SecondaryButton.dart';
import 'package:safewomen/components/custom_textfield.dart';
import 'package:safewomen/model/parent_user_model.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:safewomen/utils/constants.dart';
import 'package:safewomen/widgets/home_widgets/safehome/SafeHome.dart';
import 'package:safewomen/child/child_login_screen.dart';

class RegisterParentScreen extends StatefulWidget {
  @override
  State<RegisterParentScreen> createState() => _RegisterParentScreenState();
}

class _RegisterParentScreenState extends State<RegisterParentScreen> {
  //const RegisterParentScreen({super.key});
  bool isPasswordShown = true;
  bool isRetypePasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit() async {
    _formKey.currentState!.save();
    if (_formData['password'] != _formData['rpassword']) {
      dialogueBox(context, "Warning",
          'password and retype password should be equal', "Ok");
    } else {
      progressIndicator(context);
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _formData['parentEmail'].toString(),
                password: _formData['password'].toString());
        if (userCredential.user != null) {
          final v = userCredential.user!.uid;
          DocumentReference<Map<String, dynamic>> db =
              FirebaseFirestore.instance.collection('users').doc(v);
          final user = ParentUserModel(
            name: _formData['name'].toString(),
            childPhone: _formData['childPhone'].toString(),
            parentPhone: _formData['parentPhone'].toString(),
            childEmail: _formData['childEmail'].toString(),
            parentEmail: _formData['parentEmail'].toString(),
            id: v,
            type: 'parent',
          );
          final jsonData = user.toJson();
          await db.set(jsonData).whenComplete(() {
            //goTo(context, LoginScreen());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
            Fluttertoast.showToast(msg: "Registered Successfully");
            setState(() {
              isLoading = false;
            });
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          dialogueBox(
              context, "Warning", 'The password provided is too weak.', "Ok");
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          dialogueBox(context, "Warning",
              'The account already exists for that email.', "Ok");
        }
      } catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        dialogueBox(context, "Warning", e.toString(), "Ok");
      }
    }
    print(_formData['email']);
    print(_formData['password']);
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
          ? Center(child: progressIndicator(context))
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
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
                            height: 20,
                          ),
                          Text(
                            'REGISTER AS PARENT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              letterSpacing: 2.5,
                              fontSize: 30,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Image.asset(
                          //   'assets/logo.png',
                          //   height: 100,
                          //   width: 100,
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          Flexible(
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.2),
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.boy_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                size: 80,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Responsive(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              //
                              //
                              //name field
                              TextFormField(
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 1.5),
                                textCapitalization: TextCapitalization.words,
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
                                  hintText: 'Enter your name',
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
                                      Icons.person_outline,
                                      color: Colors.white,
                                      size: 20,
                                    )),
                                  ),
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.2),
                                ),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return "Please enter a name";
                                  } else if (name.length < 3) {
                                    return "Enter a valid name";
                                  }
                                  return null;
                                },
                                onSaved: (name) {
                                  _formData['name'] = name ?? "";
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //end of name
                              //
                              //
                              //
                              //
                              //phone
                              TextFormField(
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 1.5),
                                textCapitalization: TextCapitalization.none,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
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
                                  hintText: 'Enter your phone number',
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
                                      Icons.phone_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    )),
                                  ),
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.2),
                                ),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                validator: (phone) {
                                  if (phone!.isEmpty) {
                                    return "Please enter a phone number";
                                  } else if (phone.length < 10) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                                onSaved: (parentPhone) {
                                  _formData['parentPhone'] = parentPhone ?? "";
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //end of phone
                              //
                              //
                              //
                              //email
                              TextFormField(
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 1.5),
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
                                onSaved: (parentEmail) {
                                  _formData['parentEmail'] = parentEmail ?? "";
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //end of email
                              //
                              //
                              //
                              //
                              //phone
                              TextFormField(
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 1.5),
                                textCapitalization: TextCapitalization.none,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
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
                                  hintText: 'Enter your child phone number',
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
                                      Icons.phone_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    )),
                                  ),
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.2),
                                ),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                validator: (parentPhone) {
                                  if (parentPhone!.isEmpty) {
                                    return "Please enter a phone number";
                                  } else if (parentPhone.length < 10) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                                onSaved: (childPhone) {
                                  _formData['childPhone'] = childPhone ?? "";
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //end of phone
                              //
                              //
                              //
                              //email
                              TextFormField(
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 1.5),
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
                                  hintText: 'Enter your child email',
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
                                onSaved: (childEmail) {
                                  _formData['childEmail'] = childEmail ?? "";
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //end of email
                              //
                              //
                              //
                              //password
                              TextFormField(
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 1.5),
                                obscureText: isPasswordShown,
                                textInputAction: TextInputAction.next,
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
                                  suffixIcon: IconButton(
                                    icon: isPasswordShown
                                        ? Container(
                                            width: 40,
                                            height: 40,
                                            margin: const EdgeInsets.all(5),
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
                                              Icons.visibility_off_outlined,
                                              size: 20,
                                              color: Colors.white,
                                            )),
                                          )
                                        : Container(
                                            width: 40,
                                            height: 40,
                                            margin: const EdgeInsets.all(5),
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
                                              Icons.visibility_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordShown = !isPasswordShown;
                                      });
                                    },
                                  ),
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
                                      color: Colors.white,
                                      size: 20,
                                    )),
                                  ),
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.2),
                                  hintText: 'Enter your password',
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //end of password
                              //
                              //
                              //
                              //retype password
                              TextFormField(
                                style:
                                    TextStyle(fontSize: 15, letterSpacing: 1.5),
                                obscureText: isRetypePasswordShown,
                                textInputAction: TextInputAction.done,
                                onSaved: (password) {
                                  _formData['rpassword'] = password ?? "";
                                },
                                validator: (password) {
                                  if (password!.isEmpty) {
                                    return "Please enter a password";
                                  } else if (password.length < 7) {
                                    return "Password length should be greater than eight";
                                  }
                                  return null;
                                },
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
                                  suffixIcon: IconButton(
                                    icon: isRetypePasswordShown
                                        ? Container(
                                            width: 40,
                                            height: 40,
                                            margin: const EdgeInsets.all(5),
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
                                              Icons.visibility_off_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                          )
                                        : Container(
                                            width: 40,
                                            height: 40,
                                            margin: const EdgeInsets.all(5),
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
                                              Icons.visibility_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        isRetypePasswordShown =
                                            !isRetypePasswordShown;
                                      });
                                    },
                                  ),
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
                                      Icons.vpn_key_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    )),
                                  ),
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.2),
                                  hintText: 'Confirm your password',
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              //end of retype password
                              //
                              //
                              Container(
                                width: double.infinity,
                                height: 60,
                                child: PrimaryButton(
                                  title: 'Register',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _onSubmit();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: 8.0, bottom: 10, top: 20),
                          child: Text(
                            'Have an account ? Login',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              letterSpacing: 1.5,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
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
