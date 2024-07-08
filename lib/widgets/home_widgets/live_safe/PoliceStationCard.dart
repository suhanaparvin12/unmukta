import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PoliceStationCard extends StatelessWidget {
  final Function? onMapFunction;
  final String police = "assets/svg/police.svg";
  const PoliceStationCard({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onMapFunction!('Police stations near me');
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
                  police,
                  height: 45,
                  width: 45,
                ),
              ),
            ),
          ),
          Text('Police Stations')
        ],
      ),
    );
  }
}
