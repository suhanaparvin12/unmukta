// ignore_for_file: unused_local_variable, unnecessary_string_interpolations, prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'dart:ui';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safewomen/db/db_services.dart';
import 'package:safewomen/db/share_pref.dart';
import 'package:safewomen/model/contactsm.dart';
import 'package:safewomen/widgets/home_widgets/safehome/bottomSheet.dart';
import 'package:share_plus/share_plus.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _curentPosition;
  String? _curentAddress;
  bool continiousalert = false;
  String girl = "assets/svg/girl.svg";
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
            "${place.locality}, ${place.subLocality}, ${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void startTimer() async {
    bool value = await MySharedPrefference.getLocation();
    setState(() {
      value == true
          ? Timer.periodic(const Duration(minutes: 1), (timer) {
              alert();
            })
          : null;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
    setState(() {
      startTimer();
    });
  }

  showModelSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        //   return FractionallySizedBox(
        //     heightFactor: 0.6,
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(Icons.horizontal_rule_rounded),
        //           Spacer(),
        //           Container(
        //             height: 80,
        //             width: 80,
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(20),
        //               color: Theme.of(context).colorScheme.primary,
        //             ),
        //             child: Icon(
        //               Icons.location_on_outlined,
        //               size: 25,
        //               color: Colors.white,
        //             ),
        //           ),
        //           SizedBox(height: 15),
        //           _curentPosition == null
        //               ? Column(
        //                   children: [
        //                     Text(
        //                       "Your location is not fetched yet !",
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold, fontSize: 16),
        //                     ),
        //                     SizedBox(height: 15),
        //                     PrimaryButton(
        //                       title: "GET LOCATION",
        //                       onPressed: () {
        //                         _getCurrentLocation();
        //                       },
        //                     ),
        //                   ],
        //                 )
        //               : Text(
        //                   _curentAddress!,
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.bold, fontSize: 16),
        //                 ),
        //           SizedBox(height: 15),
        //           Text(
        //             "Share Your Location",
        //             textAlign: TextAlign.center,
        //             style: TextStyle(fontSize: 15),
        //           ),
        //           SizedBox(height: 15),
        //           PrimaryButton(
        //             title: "SEND ALERT",
        //             onPressed: () async {
        //               String recipients = "";
        //               List<TContact> contactList =
        //                   await DatabaseHelper().getContactList();
        //               print(contactList.length);
        //               if (contactList.isEmpty) {
        //                 Fluttertoast.showToast(msg: "emergency contact is empty");
        //               }
        //               if (_curentAddress == null) {
        //                 Fluttertoast.showToast(msg: "location is empty");
        //               } else {
        //                 String messageBody =
        //                     "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress";

        //                 if (await _isPermissionGranted()) {
        //                   contactList.forEach((element) {
        //                     _sendSms("${element.number}",
        //                         "I AM IN TROUBLE, PLEASE HELP ME.\nLOCATION: $messageBody");
        //                   });
        //                 } else {
        //                   Fluttertoast.showToast(msg: "something wrong");
        //                 }
        //               }
        //             },
        //           ),
        //           SizedBox(height: 15),
        //           PrimaryButton(
        //               title: "SOCIAL SHARE",
        //               onPressed: () async {
        //                 final location =
        //                     'https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress';
        //                 await Share.share(
        //                     "I AM IN TROUBLE, PLEASE HELP ME.\nLocation : $location");
        //               }),
        //           Spacer(),
        //         ],
        //       ),
        //     ),
        //   );
        // },
        return MyBottomSheet(
          curentAddress: _curentAddress,
          curentPosition: _curentPosition,
          getCurrentLocation: _getCurrentLocation,
        );
      },
    );
  }

  alert() async {
    String recipients = "";
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
        });
      } else {
        Fluttertoast.showToast(msg: "something wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModelSafeHome(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // SvgPicture.asset(
                      //   girl,
                      //   width: 150,
                      // ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Send Location",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Share your current location to your emergency contacts and others.",
                              softWrap: true,
                              style: TextStyle(fontSize: 13.5),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  PrimaryButton(
      {required this.title, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            onPressed();
          },
          // child: const Icon(
          //   Icons.arrow_forward_ios_outlined,
          //   size: 20,
          // ),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 15, color: Colors.white, letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}
