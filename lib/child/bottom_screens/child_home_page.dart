// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:background_sms/background_sms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safewomen/db/db_services.dart';
import 'package:safewomen/model/contactsm.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:safewomen/utils/constants.dart';
import 'package:safewomen/widgets/home_widgets/CustomCarouel.dart';
import 'package:safewomen/widgets/home_widgets/custom_appBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:safewomen/widgets/home_widgets/emergencies/policeenergency.dart';
import 'package:safewomen/widgets/home_widgets/emergency.dart';
import 'package:safewomen/widgets/home_widgets/safehome/SafeHome.dart';
import 'package:safewomen/widgets/live_safe.dart';
import 'package:shake/shake.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? email;
  String? profilePic;
  String? name;
  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (!mounted) return;

      setState(() {
        name = value.docs.first['name'];
        email = value.docs.first['Email'];
        //id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  //const HomeScreen({super.key});
  int qIndex = 0;

  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;
  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(msg: "send");
    } else {
      Fluttertoast.showToast(msg: "failed");
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if (!mounted) return;

      setState(() {
        _curentPosition = position;
        print(_curentPosition!.latitude);
        _getAddressFromLatLon();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      if (!mounted) return;

      setState(() {
        _curentAddress =
            "${place.locality},${place.postalCode},${place.street},";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(6);
    });
  }

  getAndSendSms() async {
    List<TContact> contactList = await DatabaseHelper().getContactList();
    print(contactList.length);
    if (contactList.isEmpty) {
      Fluttertoast.showToast(msg: "emergency contact is empty");
    }
    if (_curentAddress == null) {
      Fluttertoast.showToast(msg: "location is empty");
    } else {
      String messageBody =
          "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress";

      if (await _isPermissionGranted()) {
        contactList.forEach((element) {
          _sendSms("${element.number}",
              "I AM IN TROUBLE, PLEASE HELP ME.\nLOCATION: $messageBody");
          AudioPlayer().play(AssetSource('Success.mp3'));
        });
      } else {
        Fluttertoast.showToast(msg: "something wrong");
      }
    }
  }

  @override
  void initState() {
    _getPermission();
    _getCurrentLocation();
    getRandomQuote();
    super.initState();
    getDate();
    //////Shake feature/////
    ShakeDetector.autoStart(
      onPhoneShake: () async {
        /* await ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shake!'),
          ),
        ); */

        await getAndSendSms();
        // Do stuff on phone shake
      },
      minimumShakeCount: 3,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: ListTile(
                  title: Text(
                    name.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    email.toString(),
                    style: TextStyle(
                        color: Colors.black54, fontStyle: FontStyle.italic),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: profilePic != null
                        ? InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: AlertDialog(
                                        backgroundColor: Colors.pink.shade50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        content: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            imageUrl: profilePic!,
                                            height: 300,
                                            width: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.pink,
                              radius: 30,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(profilePic!),
                                radius: 25,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.pink,
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      */

      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:
                Theme.of(context).colorScheme.surfaceVariant,
            statusBarIconBrightness: Brightness.dark),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.toString(),
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              email.toString(),
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: profilePic != null
                ? InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: AlertDialog(
                                backgroundColor: Colors.transparent,
                                content: ClipRRect(
                                  borderRadius: BorderRadius.circular(1000000),
                                  child: CachedNetworkImage(
                                    imageUrl: profilePic!,
                                    height: 250,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profilePic!),
                      radius: 25,
                    ),
                  )
                : Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
          )
        ],
      ),
      body: name == null
          ? Center(
              child: progressIndicator(context),
            )
          : SafeArea(
              child: Responsive(
                child: Column(
                  children: [
                    /* CustomAppBar(
                quoteIndex: qIndex,
                onTap: () {
                  getRandomQuote();
                },
                          ), */
                    //Image.network(profilePic!),
                    Expanded(
                        child: ListView(
                      shrinkWrap: true,
                      children: [
                        CustomCarouel(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Emergency",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Emergency(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Explore LiveSafe",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        LiveSafe(),
                        SafeHome(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
    );
  }
}
