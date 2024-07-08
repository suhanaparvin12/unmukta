// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safewomen/components/SecondaryButton.dart';
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

class parentProfilePage extends StatefulWidget {
  const parentProfilePage({super.key});

  @override
  State<parentProfilePage> createState() => _parentProfilePageState();
}

class _parentProfilePageState extends State<parentProfilePage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController childPhoneC = TextEditingController();
  TextEditingController childEmail = TextEditingController();
  TextEditingController parentEmail = TextEditingController();
  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;

  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (!mounted) return;
      setState(() {
        nameC.text = value.docs.first['name'];
        phoneC.text = value.docs.first['Phone'];
        childPhoneC.text = value.docs.first['childPhone'];
        childEmail.text = value.docs.first['childEmail'];
        parentEmail.text = value.docs.first['Email'];
        id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
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
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Theme.of(context).colorScheme.surface,
            statusBarIconBrightness: Brightness.dark),
        toolbarHeight: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isSaving == true || nameC.text.isEmpty
          ? progressIndicator(context)
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
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
                      height: 20,
                    ),
                    Responsive(
                      child: Form(
                        key: key,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final XFile? pickImage = await ImagePicker()
                                      .pickImage(
                                          source: ImageSource.gallery,
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
                                          radius: 60,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                              .withOpacity(0.5),
                                          child: Icon(
                                            Icons.boy_outlined,
                                            size: 60,
                                          ),
                                        )
                                      : profilePic!.contains('https')
                                          ? CircleAvatar(
                                              radius: 60,
                                              backgroundImage:
                                                  NetworkImage(profilePic!),
                                            )
                                          : CircleAvatar(
                                              radius: 60,
                                              backgroundImage:
                                                  FileImage(File(profilePic!)),
                                            ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                hintText: 'Name',
                                controller: nameC,
                                keyboardtype: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                prefix: Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                ),
                                validate: (v) {
                                  if (v!.isEmpty) {
                                    return 'Please enter your updated name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                hintText: 'Email',
                                controller: parentEmail,
                                keyboardtype: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                prefix: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                ),
                                validate: (v) {
                                  if (v!.isEmpty) {
                                    return 'Please enter your updated email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                hintText: 'Phone number',
                                controller: phoneC,
                                keyboardtype: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                prefix: Icon(
                                  Icons.phone_outlined,
                                  color: Colors.white,
                                ),
                                validate: (v) {
                                  if (v!.isEmpty) {
                                    return 'Please enter your updated phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                hintText: 'Child email',
                                keyboardtype: TextInputType.emailAddress,
                                controller: childEmail,
                                textInputAction: TextInputAction.next,
                                prefix: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                ),
                                validate: (v) {
                                  if (v!.isEmpty) {
                                    return 'Please enter your updated child email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                hintText: 'Child Phone Number',
                                keyboardtype: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                prefix: Icon(
                                  Icons.phone_outlined,
                                  color: Colors.white,
                                ),
                                controller: childPhoneC,
                                validate: (v) {
                                  if (v!.isEmpty) {
                                    return 'Please enter your updated child phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              PrimaryButton(
                                title: 'UPDATE',
                                onPressed: () async {
                                  if (key.currentState!.validate()) {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    profilePic == null
                                        ? Fluttertoast.showToast(
                                            msg:
                                                'Please select profile picture')
                                        : update();
                                  }
                                },
                              ),
                              SecondaryButton(
                                  title: 'Sign out',
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    //goTo(context, LoginScreen());
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
        'childEmail': childEmail.text,
        'Email': parentEmail.text,
        'childPhone': childPhoneC.text,
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
          'childEmail': childEmail.text,
          'Email': parentEmail.text,
          'childPhone': childPhoneC.text,
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
