// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safewomen/components/SecondaryButton.dart';
import 'package:safewomen/db/share_pref.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safewomen/child/child_login_screen.dart';
import 'package:safewomen/components/PrimaryButton.dart';
import 'package:safewomen/components/custom_textfield.dart';
import 'package:safewomen/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController childEmail = TextEditingController();
  TextEditingController parentEmail = TextEditingController();
  TextEditingController parentPhone = TextEditingController();
  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? name;
  String? downloadUrl;
  bool isSaving = false;

  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          if (mounted) {
            name = value.docs.first['name'];
            nameC.text = value.docs.first['name'];
            phoneC.text = value.docs.first['Phone'];
            childEmail.text = value.docs.first['Email'];
            parentEmail.text = value.docs.first['parentEmail'];
            parentPhone.text = value.docs.first['parentPhone'];
            id = value.docs.first.id;
            profilePic = value.docs.first['profilePic'];
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:
                Theme.of(context).colorScheme.surfaceVariant,
            statusBarIconBrightness: Brightness.dark),
        leading: null,
        title: Text(
          'Profile',
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: isSaving == true
          ? Center(
              child: progressIndicator(context),
            )
          : name == null
              ? Center(
                  child: progressIndicator(context),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.logout_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                onPressed: () {
                                  MySharedPrefference.clear();
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                              ),
                            ),
                          ),
                          Responsive(
                            child: Center(
                                child: Form(
                                    key: key,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Text(
                                          //   'UPDATE YOUR PROFILE',
                                          //   style: TextStyle(
                                          //       fontSize: 25,
                                          //       fontWeight: FontWeight.bold,
                                          //       color: Colors.pink),
                                          // ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              final XFile? pickImage =
                                                  await ImagePicker().pickImage(
                                                      source:
                                                          ImageSource.gallery,
                                                      imageQuality: 50);
                                              if (pickImage != null) {
                                                setState(() {
                                                  profilePic = pickImage.path;
                                                });
                                              }
                                            },
                                            child: Container(
                                              child: profilePic == null
                                                  ? CircleAvatar(
                                                      radius: 70,
                                                      child: Icon(
                                                        Icons
                                                            .add_a_photo_outlined,
                                                        size: 25,
                                                      ),
                                                    )
                                                  : profilePic!
                                                          .contains('https')
                                                      ? CircleAvatar(
                                                          radius: 70,
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  profilePic!),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 70,
                                                          backgroundImage:
                                                              FileImage(File(
                                                                  profilePic!)),
                                                        ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          //name field
                                          TextFormField(
                                            style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.5),
                                            textCapitalization:
                                                TextCapitalization.words,
                                            maxLines: 1,
                                            controller: nameC,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              label: Text('Name'),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.2),
                                                    width: 2,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.5),
                                                    width: 2.5,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .errorContainer,
                                                    width: 2,
                                                  )),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .errorContainer,
                                                        width: 2.5,
                                                      )),
                                              border:
                                                  const OutlineInputBorder(),
                                              contentPadding:
                                                  const EdgeInsets.all(22),
                                              filled: true,
                                              hintText: 'Enter your name',
                                              prefixIcon: Container(
                                                width: 40,
                                                height: 40,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (name) {
                                              if (name!.isEmpty) {
                                                return "Please enter a name";
                                              } else if (name.length < 3) {
                                                return "Enter a valid name";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //end of name
                                          //phone
                                          TextFormField(
                                            style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.5),
                                            textCapitalization:
                                                TextCapitalization.none,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            maxLines: 1,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              label: Text('Phone'),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.2),
                                                    width: 2,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.5),
                                                    width: 2.5,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .errorContainer,
                                                    width: 2,
                                                  )),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .errorContainer,
                                                        width: 2.5,
                                                      )),
                                              border:
                                                  const OutlineInputBorder(),
                                              contentPadding:
                                                  const EdgeInsets.all(22),
                                              filled: true,
                                              hintText:
                                                  'Enter your phone number',
                                              prefixIcon: Container(
                                                width: 40,
                                                height: 40,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (phone) {
                                              if (phone!.isEmpty) {
                                                return "Please enter a phone number";
                                              } else if (phone.length < 10) {
                                                return "Enter a valid phone number";
                                              }
                                              return null;
                                            },
                                            controller: phoneC,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //end of phone
                                          //
                                          //email
                                          TextFormField(
                                            style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.5),
                                            textCapitalization:
                                                TextCapitalization.none,
                                            maxLines: 1,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              label: Text('Email'),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.2),
                                                    width: 2,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.5),
                                                    width: 2.5,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .errorContainer,
                                                    width: 2,
                                                  )),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .errorContainer,
                                                        width: 2.5,
                                                      )),
                                              border:
                                                  const OutlineInputBorder(),
                                              contentPadding:
                                                  const EdgeInsets.all(22),
                                              filled: true,
                                              hintText: 'Enter your email',
                                              prefixIcon: Container(
                                                width: 40,
                                                height: 40,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (email) {
                                              if (email!.isEmpty) {
                                                return "Please enter a email";
                                              } else if (email.length < 3 ||
                                                  !email.contains('@')) {
                                                return "Enter a valid email";
                                              }
                                              return null;
                                            },
                                            controller: childEmail,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //end of email
                                          //
                                          //email
                                          TextFormField(
                                            style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.5),
                                            textCapitalization:
                                                TextCapitalization.none,
                                            maxLines: 1,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              label: Text('Parent Email'),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.2),
                                                    width: 2,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.5),
                                                    width: 2.5,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .errorContainer,
                                                    width: 2,
                                                  )),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .errorContainer,
                                                        width: 2.5,
                                                      )),
                                              border:
                                                  const OutlineInputBorder(),
                                              contentPadding:
                                                  const EdgeInsets.all(22),
                                              filled: true,
                                              hintText:
                                                  'Enter your parent email',
                                              prefixIcon: Container(
                                                width: 40,
                                                height: 40,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (email) {
                                              if (email!.isEmpty) {
                                                return "Please enter a email";
                                              } else if (email.length < 3 ||
                                                  !email.contains('@')) {
                                                return "Enter a valid email";
                                              }
                                              return null;
                                            },
                                            controller: parentEmail,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //end of email
                                          //
                                          TextFormField(
                                            style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.5),
                                            textCapitalization:
                                                TextCapitalization.none,
                                            maxLines: 1,
                                            autofocus: false,
                                            decoration: InputDecoration(
                                              label: Text('Parent Phone'),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.2),
                                                    width: 2,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.5),
                                                    width: 2.5,
                                                  )),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .errorContainer,
                                                    width: 2,
                                                  )),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .errorContainer,
                                                        width: 2.5,
                                                      )),
                                              border:
                                                  const OutlineInputBorder(),
                                              contentPadding:
                                                  const EdgeInsets.all(22),
                                              filled: true,
                                              hintText:
                                                  'Enter your parent phone',
                                              prefixIcon: Container(
                                                width: 40,
                                                height: 40,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inversePrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                            keyboardType:
                                                TextInputType.phone,
                                            textInputAction:
                                                TextInputAction.done,
                                            validator: (phone) {
                                              if (phone!.isEmpty) {
                                                return "Please enter a phone number";
                                              } else if (phone.length < 10) {
                                                return "Enter a valid phone number";
                                              }
                                              return null;
                                            },
                                            controller: parentPhone,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //
                                          PrimaryButton(
                                              title: 'UPDATE',
                                              onPressed: () async {
                                                if (key.currentState!
                                                    .validate()) {
                                                  SystemChannels.textInput
                                                      .invokeMethod(
                                                          'TextInput.hide');
                                                  profilePic == null
                                                      ? Fluttertoast.showToast(
                                                          msg:
                                                              'Please select profile picture')
                                                      : profilePic!
                                                              .contains('https')
                                                          ? update()
                                                          : update();
                                                }
                                              }),
                                          SecondaryButton(
                                            title: 'Sign out',
                                            onPressed: () {
                                              MySharedPrefference.clear();
                                              FirebaseAuth.instance.signOut();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final filenName = Uuid().v4();
      final Reference fbStorage =
          FirebaseStorage.instance.ref('profile').child(filenName);
      final UploadTask uploadTask = fbStorage.putFile(File(filePath));
      await uploadTask.then((p0) async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  update() async {
    setState(() {
      isSaving = true;
    });
    if (profilePic!.contains('http')) {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'Phone': phoneC.text,
        'Email': childEmail.text,
        'parentEmail': parentEmail.text,
        'parentPhone': parentPhone.text,
        'profilePic': profilePic,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
      setState(() {
        isSaving = false;
      });
      Fluttertoast.showToast(msg: 'Changes saved');
    } else {
      uploadImage(profilePic!).then((value) {
        Map<String, dynamic> data = {
          'name': nameC.text,
          'Phone': phoneC.text,
          'Email': childEmail.text,
          'parentEmail': parentEmail.text,
          'parentPhone': parentPhone.text,
          'profilePic': downloadUrl,
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(data);
        setState(() {
          isSaving = false;
        });
        Fluttertoast.showToast(msg: 'Profile picture updated');
      });
    }
  }
}
