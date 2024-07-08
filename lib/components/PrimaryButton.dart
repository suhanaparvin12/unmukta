import 'package:flutter/material.dart';
import 'package:safewomen/responsive/responsive.dart';
import 'package:safewomen/utils/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  PrimaryButton(
      {required this.title, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      child: Container(
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
      ),
    );
  }
}
