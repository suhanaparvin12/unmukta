import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PharmacyCard extends StatelessWidget {
  final Function? onMapFunction;
  final String pharmacy = "assets/svg/medicines.svg";

  const PharmacyCard({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onMapFunction!('pharmacies+near+me');
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
                pharmacy,
                width: 35,
                height: 35,
              )),
            ),
          ),
          Text('Pharmacy')
        ],
      ),
    );
  }
}
