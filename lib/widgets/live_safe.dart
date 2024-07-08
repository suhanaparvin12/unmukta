import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_widgets/safehome/SafeHome.dart';
import 'home_widgets/live_safe/BusStationCard.dart';
import 'home_widgets/live_safe/HospitalCard.dart';
import 'home_widgets/live_safe/PharmacyCard.dart';
import 'home_widgets/live_safe/PoliceStationCard.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({Key? key}) : super(key: key);

  static Future<void> openMap(String location) async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();

    if (servicestatus) {
      Fluttertoast.showToast(msg: "GPS service is enabled");
    } else {
      Fluttertoast.showToast(msg: "GPS service is disabled");
    }

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );
    late Position position;
    String long = "", lat = "";

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457
    });

    String googleUrl = 'https://www.google.com/maps/search/$location/';
    print(googleUrl);

    if (Platform.isAndroid) {
      if (await canLaunchUrl(Uri.parse(googleUrl))) {
        await launchUrl(Uri.parse(googleUrl),
            mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $googleUrl';
      }
    } else {
      final Uri _url = Uri.parse(googleUrl);
      try {
        await launchUrl(_url, mode: LaunchMode.externalApplication);
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'something went wrong! call emergency number');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceStationCard(onMapFunction: openMap),
          HospitalCard(onMapFunction: openMap),
          PharmacyCard(onMapFunction: openMap),
          BusStationCard(onMapFunction: openMap),
        ],
      ),
    );
  }
}
