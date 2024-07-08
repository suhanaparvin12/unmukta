import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class BusStationCard extends StatelessWidget {
  final Function? onMapFunction;
  openMap(String place) async {
    final url = "https://www.google.com/maps/place/$place";

    final Uri _url = Uri.parse(url);

    await launchUrl(_url, mode: LaunchMode.platformDefault);
  }

  const BusStationCard({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String bus = "assets/svg/bus.svg";
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onMapFunction!('bus stops near me');
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.2)),
              height: 55,
              width: 55,
              child: Center(
                child: SvgPicture.asset(
                  bus,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
          Text('Bus Stations')
        ],
      ),
    );
  }
}
