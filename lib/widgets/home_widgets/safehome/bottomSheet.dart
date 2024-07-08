import 'dart:async';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safewomen/db/db_services.dart';
import 'package:safewomen/db/share_pref.dart';
import 'package:safewomen/model/contactsm.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:safewomen/widgets/home_widgets/safehome/SafeHome.dart';
import 'package:share_plus/share_plus.dart';

class MyBottomSheet extends StatefulWidget {
  final VoidCallback getCurrentLocation;

  final Position? curentPosition;
  final String? curentAddress;

  const MyBottomSheet({
    super.key,
    required this.curentPosition,
    required this.getCurrentLocation,
    required this.curentAddress,
  });

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
//
  bool continiousalert = false;
  ScrollController scrollController = ScrollController();
  //
  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  //
  //
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
  //

  Future<void> _initializeSwitchState() async {
    bool savedValue = await MySharedPrefference.getLocation();
    setState(() {
      continiousalert = savedValue;
    });
  }

  void alert() async {
    String recipients = "";
    List<TContact> contactList = await DatabaseHelper().getContactList();
    print(contactList.length);
    if (contactList.isEmpty) {
      Fluttertoast.showToast(msg: "emergency contact is empty");
    }
    if (widget.curentAddress == null) {
      Fluttertoast.showToast(msg: "location is empty");
    } else {
      String messageBody =
          "https://www.google.com/maps/search/?api=1&query=${widget.curentPosition!.latitude}%2C${widget.curentPosition!.longitude}. $widget.curentAddress";

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeSwitchState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 1, // Initial size of the bottom sheet
        minChildSize: 0.4, // Minimum size when fully collapsed
        maxChildSize: 1, // Maximum size when fully expanded
        expand: false, // Whether the sheet should expand initially
        builder: (context, scrollController) {
          return Responsive(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              controller: scrollController,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.horizontal_rule_rounded),
                const SizedBox(height: 15),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                widget.curentPosition == null
                    ? Column(
                        children: [
                          const Text(
                            "Your location is not fetched yet !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 15),
                          PrimaryButton(
                            title: "GET LOCATION",
                            onPressed: () {
                              widget.getCurrentLocation;
                            },
                          ),
                        ],
                      )
                    : Text(
                        widget.curentAddress!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                const SizedBox(height: 15),
                const Text(
                  "Share Your Location",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 5),
                Switch(
                  value: continiousalert,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      continiousalert = value;
                      MySharedPrefference.saveLocation(value);
                    });
                  },
                ),
                const Text(
                  "Share your current location in each 10 minutes to your emergency contacts and others.",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5),
                ),
                const SizedBox(
                  height: 15,
                ),
                PrimaryButton(
                  title: "SEND ALERT",
                  onPressed: () async {
                    alert();
                  },
                ),
                const SizedBox(height: 15),
                PrimaryButton(
                    title: "SOCIAL SHARE",
                    onPressed: () async {
                      final location =
                          'https://www.google.com/maps/search/?api=1&query=${widget.curentPosition!.latitude}%2C${widget.curentPosition!.longitude}. $widget.curentAddress';
                      await Share.share(
                          "I AM IN TROUBLE, PLEASE HELP ME.\nLocation : $location");
                    }),
                const SizedBox(height: 15),
              ],
            ),
          );
        });
    ;
  }
}
